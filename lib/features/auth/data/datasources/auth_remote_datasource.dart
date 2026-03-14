import 'package:dummyexpense/core/error/exceptions.dart';
import 'package:dummyexpense/core/network/api_client.dart';
import 'package:dummyexpense/core/utils/constants.dart';
import 'package:dummyexpense/features/auth/data/models/auth_response_model.dart';
import 'package:dummyexpense/features/auth/data/models/create_account_response_model.dart';

abstract class AuthRemoteDataSource {
  /// Calls the POST /auth/send-otp/ endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<AuthResponseModel> sendOtp(String phone);

  /// Calls the POST /auth/create-account/ endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<CreateAccountResponseModel> createAccount(String phone, String nickname);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> sendOtp(String phone) async {
    try {
      final response = await apiClient.post(
        AppConstants.sendOtpPath,
        data: {'phone': phone},
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response.data['message']?.toString() ?? 'Failed to send OTP',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CreateAccountResponseModel> createAccount(String phone, String nickname) async {
    try {
      final response = await apiClient.post(
        AppConstants.createAccountPath,
        data: {'phone': phone, 'nickname': nickname},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateAccountResponseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response.data['message']?.toString() ?? 'Failed to create account',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
