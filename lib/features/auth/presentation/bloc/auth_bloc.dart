import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyexpense/features/auth/domain/usecases/send_otp.dart';
import 'package:dummyexpense/features/auth/domain/usecases/create_account.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_event.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtp sendOtpUseCase;
  final CreateAccount createAccountUseCase;

  String _lastPhone = '';
  String _currentOtp = '';
  bool _userExists = false;
  String? _nickname;
  String _token = '';

  AuthBloc({
    required this.sendOtpUseCase,
    required this.createAccountUseCase,
  }) : super(const AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<ResetAuthEvent>(_onReset);
    on<CreateAccountEvent>(_onCreateAccount);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    _lastPhone = event.phone;

    final result = await sendOtpUseCase(event.phone);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (authResponse) {
        _currentOtp = authResponse.otp;
        _userExists = authResponse.userExists;
        _nickname = authResponse.nickname;
        _token = authResponse.token;

        emit(OtpSentState(
          otp: authResponse.otp,
          phone: event.phone,
          userExists: authResponse.userExists,
          nickname: authResponse.nickname,
          token: authResponse.token,
        ));
      },
    );
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    // Local OTP verification
    if (event.enteredOtp == _currentOtp) {
      if (_userExists) {
        // Existing user – go directly to Home
        emit(OtpVerifiedState(
          userExists: true,
          nickname: _nickname,
          token: _token,
        ));
      } else {
        // New user – need to collect a nickname first
        emit(NicknameRequiredState(
          phone: _lastPhone,
          token: _token,
        ));
      }
    } else {
      emit(const AuthError(message: 'Invalid OTP. Please try again.'));
    }
  }

  Future<void> _onCreateAccount(CreateAccountEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await createAccountUseCase(event.phone, event.nickname);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (response) {
        _token = response.token;
        _nickname = event.nickname;
        emit(AccountCreatedState(token: response.token));
      },
    );
  }

  Future<void> _onResendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    if (_lastPhone.isNotEmpty) {
      add(SendOtpEvent(phone: _lastPhone));
    }
  }

  void _onReset(ResetAuthEvent event, Emitter<AuthState> emit) {
    _lastPhone = '';
    _currentOtp = '';
    _userExists = false;
    _nickname = null;
    _token = '';
    emit(const AuthInitial());
  }
}
