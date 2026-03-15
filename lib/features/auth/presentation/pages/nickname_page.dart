import 'package:dummyexpense/core/constants/colors.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_event.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_state.dart';
import 'package:dummyexpense/features/home/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class NicknamePage extends StatefulWidget {
  final String phone;

  const NicknamePage({super.key, required this.phone});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final _nicknameController = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _nicknameController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nicknameController.removeListener(_onTextChanged);
    _nicknameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) return;

    context.read<AuthBloc>().add(
      CreateAccountEvent(phone: widget.phone, nickname: nickname),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AccountCreatedState) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Account created successfully! Welcome!',
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else if (state is AuthError) {
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
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                Text(
                  '👋 What should we call you?',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'This name stays only on your device.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFC7C7CC),
                  ),
                ),

                const SizedBox(height: 48),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _nicknameController,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: AppColors.white,
                    ),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Eg: Johnnnie',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 18,
                        color: const Color(0xFF48484A),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      suffixIcon: _hasText
                          ? const Icon(
                              Icons.check_circle,
                              color: Color(0xFF34C759),
                              size: 24,
                            )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (isLoading || !_hasText) ? null : _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: AppColors.primaryBlue.withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                                'Continue',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
