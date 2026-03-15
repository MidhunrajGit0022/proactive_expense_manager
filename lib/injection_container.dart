import 'package:dummyexpense/core/database/database_helper.dart';
import 'package:dummyexpense/core/network/api_client.dart';
import 'package:dummyexpense/core/notifications/notification_service.dart';
import 'package:dummyexpense/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dummyexpense/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dummyexpense/features/auth/domain/usecases/create_account.dart';
import 'package:dummyexpense/features/auth/domain/usecases/send_otp.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dummyexpense/features/category/data/datasources/category_local_datasource.dart';
import 'package:dummyexpense/features/category/data/datasources/category_remote_datasource.dart';
import 'package:dummyexpense/features/category/data/repositories/category_repository_impl.dart';
import 'package:dummyexpense/features/category/domain/usecases/add_category.dart';
import 'package:dummyexpense/features/category/domain/usecases/delete_category.dart';
import 'package:dummyexpense/features/category/domain/usecases/get_categories.dart';
import 'package:dummyexpense/features/category/presentation/bloc/category_bloc.dart';
import 'package:dummyexpense/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:dummyexpense/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:dummyexpense/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:dummyexpense/features/transaction/domain/usecases/add_transaction.dart';
import 'package:dummyexpense/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:dummyexpense/features/transaction/domain/usecases/get_transactions.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:dummyexpense/features/sync/data/sync_service.dart';
import 'package:dummyexpense/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class InjectionContainer {
  static late final SharedPreferences _sharedPreferences;
  static late final ApiClient _apiClient;
  static late final DatabaseHelper _databaseHelper;
  static late final NotificationService _notificationService;
  static const Uuid _uuid = Uuid();

  static late final AuthRemoteDataSourceImpl _authRemoteDataSource;
  static late final AuthRepositoryImpl _authRepository;
  static late final SendOtp _sendOtp;
  static late final CreateAccount _createAccount;

  static late final CategoryLocalDataSourceImpl _categoryLocalDataSource;
  static late final CategoryRemoteDataSourceImpl _categoryRemoteDataSource;
  static late final CategoryRepositoryImpl _categoryRepository;
  static late final GetCategories _getCategories;
  static late final AddCategory _addCategory;
  static late final DeleteCategory _deleteCategory;

  static late final TransactionLocalDataSourceImpl _transactionLocalDataSource;
  static late final TransactionRemoteDataSourceImpl _transactionRemoteDataSource;
  static late final TransactionRepositoryImpl _transactionRepository;
  static late final GetTransactions _getTransactions;
  static late final AddTransaction _addTransaction;
  static late final DeleteTransaction _deleteTransaction;

  static late final SyncService _syncService;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _apiClient = ApiClient();
    _databaseHelper = DatabaseHelper();
    _notificationService = NotificationService();
    await _notificationService.init();

    await _databaseHelper.database;

    _authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient: _apiClient);
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
      sharedPreferences: _sharedPreferences,
    );
    _sendOtp = SendOtp(_authRepository);
    _createAccount = CreateAccount(_authRepository);

    _categoryLocalDataSource = CategoryLocalDataSourceImpl(databaseHelper: _databaseHelper);
    _categoryRemoteDataSource = CategoryRemoteDataSourceImpl(apiClient: _apiClient);
    _categoryRepository = CategoryRepositoryImpl(
      localDataSource: _categoryLocalDataSource,
      remoteDataSource: _categoryRemoteDataSource,
      uuid: _uuid,
    );
    _getCategories = GetCategories(_categoryRepository);
    _addCategory = AddCategory(_categoryRepository);
    _deleteCategory = DeleteCategory(_categoryRepository);

    _transactionLocalDataSource = TransactionLocalDataSourceImpl(databaseHelper: _databaseHelper);
    _transactionRemoteDataSource = TransactionRemoteDataSourceImpl(apiClient: _apiClient);
    _transactionRepository = TransactionRepositoryImpl(
      localDataSource: _transactionLocalDataSource,
      remoteDataSource: _transactionRemoteDataSource,
      uuid: _uuid,
    );
    _getTransactions = GetTransactions(_transactionRepository);
    _addTransaction = AddTransaction(_transactionRepository);
    _deleteTransaction = DeleteTransaction(_transactionRepository);

    _syncService = SyncService(
      categoryRepository: _categoryRepository,
      transactionRepository: _transactionRepository,
    );
  }

  static AuthBloc get authBloc => AuthBloc(
        sendOtpUseCase: _sendOtp,
        createAccountUseCase: _createAccount,
      );

  static CategoryBloc get categoryBloc => CategoryBloc(
        getCategories: _getCategories,
        addCategory: _addCategory,
        deleteCategory: _deleteCategory,
      );

  static TransactionBloc get transactionBloc => TransactionBloc(
        getTransactions: _getTransactions,
        addTransaction: _addTransaction,
        deleteTransaction: _deleteTransaction,
        repository: _transactionRepository,
        sharedPreferences: _sharedPreferences,
        notificationService: _notificationService,
      );

  static SyncBloc get syncBloc => SyncBloc(syncService: _syncService);
}
