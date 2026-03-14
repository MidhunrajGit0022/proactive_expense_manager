import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dummyexpense/core/utils/constants.dart';
import 'package:dummyexpense/features/transaction/domain/usecases/get_transactions.dart';
import 'package:dummyexpense/features/transaction/domain/usecases/add_transaction.dart';
import 'package:dummyexpense/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:dummyexpense/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:dummyexpense/core/notifications/notification_service.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;
  final TransactionRepository repository;
  final SharedPreferences sharedPreferences;
  final NotificationService notificationService;

  TransactionBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.deleteTransaction,
    required this.repository,
    required this.sharedPreferences,
    required this.notificationService,
  }) : super(const TransactionInitial()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<LoadRecentTransactionsEvent>(_onLoadRecentTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    final result = await getTransactions();
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transactions) => emit(TransactionLoaded(transactions: transactions)),
    );
  }

  Future<void> _onLoadRecentTransactions(
    LoadRecentTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    final result = await getTransactions.recent(event.limit);
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transactions) => emit(TransactionLoaded(transactions: transactions)),
    );
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await addTransaction(
      amount: event.amount,
      note: event.note,
      type: event.type,
      categoryId: event.categoryId,
    );

    await result.fold(
      (failure) async => emit(TransactionError(message: failure.message)),
      (transaction) async {
        // Check budget limit for debit transactions
        if (event.type == 'debit') {
          final limitResult = await repository.getMonthlyTotal('debit');
          await limitResult.fold(
            (_) async {},
            (monthlyTotal) async {
              final limit = sharedPreferences.getDouble(AppConstants.budgetLimitKey) ??
                  AppConstants.defaultBudgetLimit;
              if (monthlyTotal > limit) {
                await notificationService.showBudgetAlert(monthlyTotal, limit);
              }
            },
          );
        }
        emit(const TransactionAdded());
      },
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await deleteTransaction(event.id);
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (_) => emit(const TransactionDeleted()),
    );
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final incomeResult = await repository.getTotalByType('credit');
    final expenseResult = await repository.getTotalByType('debit');
    final monthlyResult = await repository.getMonthlyTotal('debit');
    final recentResult = await repository.getRecentTransactions(10);
    final budgetLimit = sharedPreferences.getDouble(AppConstants.budgetLimitKey) ??
        AppConstants.defaultBudgetLimit;

    double totalIncome = 0;
    double totalExpense = 0;
    double monthlyExpense = 0;

    incomeResult.fold((_) {}, (v) => totalIncome = v);
    expenseResult.fold((_) {}, (v) => totalExpense = v);
    monthlyResult.fold((_) {}, (v) => monthlyExpense = v);

    recentResult.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transactions) => emit(DashboardLoaded(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        monthlyExpense: monthlyExpense,
        budgetLimit: budgetLimit,
        recentTransactions: transactions,
      )),
    );
  }
}
