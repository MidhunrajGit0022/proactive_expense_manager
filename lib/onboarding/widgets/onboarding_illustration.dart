import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class OnboardingIllustration extends StatelessWidget {
  final int index;

  const OnboardingIllustration({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Image.asset(
            'assets/png/backgroundimage.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
                stops: [0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
