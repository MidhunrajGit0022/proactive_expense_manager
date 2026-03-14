import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String status;
  final String otp;
  final bool userExists;
  final String? nickname;
  final String token;

  const AuthResponse({
    required this.status,
    required this.otp,
    required this.userExists,
    this.nickname,
    required this.token,
  });

  @override
  List<Object?> get props => [status, otp, userExists, nickname, token];
}
