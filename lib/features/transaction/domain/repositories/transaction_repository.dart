import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions();
  Future<Either<Failure, List<TransactionEntity>>> getRecentTransactions(int limit);
  Future<Either<Failure, TransactionEntity>> addTransaction({
    required double amount,
    required String note,
    required String type,
    required String categoryId,
  });
  Future<Either<Failure, void>> deleteTransaction(String id);
  Future<Either<Failure, double>> getTotalByType(String type);
  Future<Either<Failure, double>> getMonthlyTotal(String type);
  Future<Either<Failure, List<String>>> syncTransactions();
  Future<Either<Failure, List<String>>> purgeDeletedTransactions();
}
