import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/transaction/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteTransaction(id);
  }
}
