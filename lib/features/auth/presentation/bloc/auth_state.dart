import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class OtpSentState extends AuthState {
  final String otp;
  final String phone;
  final bool userExists;
  final String? nickname;
  final String token;

  const OtpSentState({
    required this.otp,
    required this.phone,
    required this.userExists,
    this.nickname,
    required this.token,
  });

  @override
  List<Object?> get props => [otp, phone, userExists, nickname, token];
}

class OtpVerifiedState extends AuthState {
  final bool userExists;
  final String? nickname;
  final String token;

  const OtpVerifiedState({
    required this.userExists,
    this.nickname,
    required this.token,
  });

  @override
  List<Object?> get props => [userExists, nickname, token];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class NicknameRequiredState extends AuthState {
  final String phone;
  final String token;

  const NicknameRequiredState({required this.phone, required this.token});

  @override
  List<Object?> get props => [phone, token];
}

class AccountCreatedState extends AuthState {
  final String token;

  const AccountCreatedState({required this.token});

  @override
  List<Object?> get props => [token];
}
