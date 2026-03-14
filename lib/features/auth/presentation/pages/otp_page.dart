import 'dart:async';
import 'package:dummyexpense/core/constants/colors.dart';
import 'package:dummyexpense/core/utils/constants.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_event.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_state.dart';
import 'package:dummyexpense/features/auth/presentation/pages/nickname_page.dart';
import 'package:dummyexpense/features/auth/presentation/widgets/otp_input_field.dart';
import 'package:dummyexpense/features/home/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  final String otp;

  const OtpPage({super.key, required this.phone, required this.otp});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    AppConstants.otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    AppConstants.otpLength,
    (_) => FocusNode(),
  );

  Timer? _resendTimer;
  int _resendSeconds = AppConstants.otpResendSeconds;
  bool _canResend = false;
  late String _displayOtp;

  @override
  void initState() {
    super.initState();
    _displayOtp = widget.otp;
    _startResendTimer();
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = AppConstants.otpResendSeconds;
    _canResend = false;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendSeconds > 0) {
            _resendSeconds--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  String get _maskedPhone {
    final phone = widget.phone.replaceAll('+91', '');
    if (phone.length >= 10) {
      return '+91 ${phone.substring(0, 4)}****${phone.substring(8)}';
    }
    return phone;
  }

  String get _enteredOtp {
    return _otpControllers.map((c) => c.text).join();
  }

  void _verifyOtp() {
    final otp = _enteredOtp;
    if (otp.length != AppConstants.otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter the complete ${AppConstants.otpLength}-digit OTP',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(VerifyOtpEvent(enteredOtp: otp));
  }

  void _onResend() {
    if (_canResend) {
      context.read<AuthBloc>().add(const ResendOtpEvent());
      _startResendTimer();
    }
  }

  void _clearOtp() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerifiedState) {
            // Existing user – navigate to Home (pop to first route)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Welcome back${state.nickname != null ? ", ${state.nickname}" : ""}!',
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false,
            );
          } else if (state is NicknameRequiredState) {
            // New user – navigate to Nickname page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AuthBloc>(),
                  child: NicknamePage(phone: state.phone),
                ),
              ),
            );
          } else if (state is AuthError) {
            _clearOtp();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: GoogleFonts.inter()),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else if (state is OtpSentState) {
            // OTP resent – update the displayed OTP
            setState(() {
              _displayOtp = state.otp;
            });
            _clearOtp();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'OTP resent successfully',
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2C2C2E),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  'Verify OTP',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle with masked phone
                Text(
                  'Enter the 6-Digit code sent to $_maskedPhone',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 4),

                // Change Number link
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Change Number',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // OTP Display Banner (for testing)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryBlue,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Your OTP: ',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGrey,
                        ),
                      ),
                      Text(
                        _displayOtp,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    AppConstants.otpLength,
                    (index) => OtpInputField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      nextFocusNode: index < AppConstants.otpLength - 1
                          ? _focusNodes[index + 1]
                          : null,
                      previousFocusNode:
                          index > 0 ? _focusNodes[index - 1] : null,
                      autoFocus: index == 0,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Verify Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor:
                              AppColors.primaryBlue.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                'Verify',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Resend OTP
                Row(
                  children: [
                    Text(
                      'Resend OTP in  ',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGrey,
                      ),
                    ),
                    if (!_canResend)
                      Text(
                        '${_resendSeconds}s',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _onResend,
                        child: Text(
                          'Resend',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
