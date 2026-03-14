import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/auth/domain/entities/auth_response.dart';
import 'package:dummyexpense/features/auth/domain/entities/create_account_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> sendOtp(String phone);
  Future<Either<Failure, CreateAccountResponse>> createAccount(String phone, String nickname);
}
