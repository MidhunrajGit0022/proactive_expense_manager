import 'package:dartz/dartz.dart';
import 'package:dummyexpense/core/error/exceptions.dart';
import 'package:dummyexpense/core/error/failures.dart';
import 'package:dummyexpense/core/utils/constants.dart';
import 'package:dummyexpense/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dummyexpense/features/auth/domain/entities/auth_response.dart';
import 'package:dummyexpense/features/auth/domain/entities/create_account_response.dart';
import 'package:dummyexpense/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, AuthResponse>> sendOtp(String phone) async {
    try {
      final response = await remoteDataSource.sendOtp(phone);

      await sharedPreferences.setString(AppConstants.authTokenKey, response.token);
      await sharedPreferences.setString(AppConstants.phoneKey, phone);
      if (response.nickname != null) {
        await sharedPreferences.setString(AppConstants.nicknameKey, response.nickname!);
      }

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CreateAccountResponse>> createAccount(String phone, String nickname) async {
    try {
      final response = await remoteDataSource.createAccount(phone, nickname);

      await sharedPreferences.setString(AppConstants.authTokenKey, response.token);
      await sharedPreferences.setString(AppConstants.nicknameKey, nickname);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
