import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:dummyexpense/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:dummyexpense/features/transaction/data/models/transaction_model.dart';
import 'package:dummyexpense/features/transaction/domain/entities/transaction_entity.dart';
import 'package:dummyexpense/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:uuid/uuid.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;
  final Uuid uuid;

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.uuid,
  });

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions() async {
    try {
      final transactions = await localDataSource.getTransactions();
      return Right(transactions);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getRecentTransactions(int limit) async {
    try {
      final transactions = await localDataSource.getRecentTransactions(limit);
      return Right(transactions);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> addTransaction({
    required double amount,
    required String note,
    required String type,
    required String categoryId,
  }) async {
    try {
      final transaction = TransactionModel(
        id: uuid.v4(),
        amount: amount,
        note: note,
        type: type,
        categoryId: categoryId,
        isSynced: false,
        isDeleted: false,
        timestamp: DateTime.now(),
      );
      await localDataSource.insertTransaction(transaction);
      // Re-fetch to get the JOIN'd category name
      final allTransactions = await localDataSource.getRecentTransactions(1);
      if (allTransactions.isNotEmpty) {
        return Right(allTransactions.first);
      }
      return Right(transaction);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.softDeleteTransaction(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalByType(String type) async {
    try {
      final total = await localDataSource.getTotalByType(type);
      return Right(total);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getMonthlyTotal(String type) async {
    try {
      final total = await localDataSource.getMonthlyTotal(type);
      return Right(total);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> syncTransactions() async {
    try {
      final unsynced = await localDataSource.getUnsyncedTransactions();
      if (unsynced.isEmpty) return const Right([]);
      final syncedIds = await remoteDataSource.addTransactions(unsynced);
      await localDataSource.markAsSynced(syncedIds);
      return Right(syncedIds);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> purgeDeletedTransactions() async {
    try {
      final deleted = await localDataSource.getDeletedTransactions();
      if (deleted.isEmpty) return const Right([]);
      final ids = deleted.map((t) => t.id).toList();
      final deletedIds = await remoteDataSource.deleteTransactions(ids);
      await localDataSource.permanentlyDelete(deletedIds);
      return Right(deletedIds);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
