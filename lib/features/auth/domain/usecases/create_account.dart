import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/auth/domain/entities/create_account_response.dart';
import 'package:dummyexpense/features/auth/domain/repositories/auth_repository.dart';

class CreateAccount {
  final AuthRepository repository;

  CreateAccount(this.repository);

  Future<Either<Failure, CreateAccountResponse>> call(String phone, String nickname) {
    return repository.createAccount(phone, nickname);
  }
}
