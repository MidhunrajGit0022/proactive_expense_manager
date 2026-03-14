import 'package:dummyexpense/features/auth/domain/entities/auth_response.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.status,
    required super.otp,
    required super.userExists,
    super.nickname,
    required super.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      status: json['status'] as String? ?? '',
      otp: json['otp']?.toString() ?? '',
      userExists: json['user_exists'] as bool? ?? false,
      nickname: json['nickname'] as String?,
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'otp': otp,
      'user_exists': userExists,
      'nickname': nickname,
      'token': token,
    };
  }
}
