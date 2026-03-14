import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/features/auth/domain/entities/auth_response.dart';
import 'package:dummyexpense/features/auth/domain/repositories/auth_repository.dart';

class SendOtp {
  final AuthRepository repository;

  SendOtp(this.repository);

  Future<Either<Failure, AuthResponse>> call(String phone) {
    return repository.sendOtp(phone);
  }
}
