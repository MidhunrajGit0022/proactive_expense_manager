import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/transaction/domain/entities/transaction_entity.dart';
import 'package:dummyexpense/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call() {
    return repository.getTransactions();
  }

  Future<Either<Failure, List<TransactionEntity>>> recent(int limit) {
    return repository.getRecentTransactions(limit);
  }
}
