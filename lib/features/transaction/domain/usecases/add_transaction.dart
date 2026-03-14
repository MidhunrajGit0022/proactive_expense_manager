import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/transaction/domain/entities/transaction_entity.dart';
import 'package:dummyexpense/features/transaction/domain/repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<Either<Failure, TransactionEntity>> call({
    required double amount,
    required String note,
    required String type,
    required String categoryId,
  }) {
    return repository.addTransaction(
      amount: amount,
      note: note,
      type: type,
      categoryId: categoryId,
    );
  }
}
