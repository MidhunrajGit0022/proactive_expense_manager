import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;

  const SendOtpEvent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String enteredOtp;

  const VerifyOtpEvent({required this.enteredOtp});

  @override
  List<Object?> get props => [enteredOtp];
}

class ResendOtpEvent extends AuthEvent {
  const ResendOtpEvent();
}

class ResetAuthEvent extends AuthEvent {
  const ResetAuthEvent();
}

class CreateAccountEvent extends AuthEvent {
  final String phone;
  final String nickname;

  const CreateAccountEvent({required this.phone, required this.nickname});

  @override
  List<Object?> get props => [phone, nickname];
}
