import 'package:dummyexpense/core/error/exceptions.dart';
import 'package:dummyexpense/core/network/api_client.dart';
import 'package:dummyexpense/core/utils/constants.dart';
import 'package:dummyexpense/features/transaction/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<List<String>> addTransactions(List<TransactionModel> transactions);
  Future<List<String>> deleteTransactions(List<String> ids);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient apiClient;

  TransactionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final response = await apiClient.get(AppConstants.transactionsPath);
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      final list = response.data['transactions'] as List?;
      return list?.map((e) => TransactionModel.fromJson(e)).toList() ?? [];
    }
    throw ServerException(
      message: response.data['message'] ?? 'Failed to fetch transactions',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<List<String>> addTransactions(List<TransactionModel> transactions) async {
    final response = await apiClient.post(
      AppConstants.addTransactionsPath,
      data: {
        'transactions': transactions.map((t) => t.toApiJson()).toList(),
      },
    );
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      final ids = response.data['synced_ids'] as List?;
      return ids?.map((e) => e.toString()).toList() ?? [];
    }
    throw ServerException(
      message: response.data['message'] ?? 'Failed to sync transactions',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<List<String>> deleteTransactions(List<String> ids) async {
    final response = await apiClient.delete(
      AppConstants.deleteTransactionsPath,
      data: {'ids': ids},
    );
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      final deletedIds = response.data['deleted_ids'] as List?;
      return deletedIds?.map((e) => e.toString()).toList() ?? [];
    }
    throw ServerException(
      message: response.data['message'] ?? 'Failed to delete transactions',
      statusCode: response.statusCode,
    );
  }
}
