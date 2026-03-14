import 'package:dummyexpense/core/global.dart/global.dart';
import 'package:dummyexpense/features/auth/presentation/pages/login_page.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dummyexpense/onboarding/widgets/onboarding_button.dart';
import 'package:dummyexpense/onboarding/widgets/onboarding_illustration.dart';
import 'package:dummyexpense/onboarding/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _pages = [
    {
      'title': 'Privacy by Default, With Zero Ads or Hidden Tracking',
      'description': 'No ads. No trackers. No third-party analytics.',
      'button': 'Next',
    },
    {
      'title': 'Insights That Help You Spend Better Without Complexity',
      'description': 'See category-wise spending, recent activity.',
      'button': 'Next',
    },
    {
      'title': 'Local-First Tracking That Stays Fully On Your Device',
      'description': 'Your finances stay on your phone.',
      'button': 'Get Started',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: Scaffold(
        body: BlocConsumer<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingPageState) {
              _pageController.animateToPage(
                state.index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            } else if (state is OnboardingFinished) {
              pr("move to login");
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AuthBloc>(),
                    child: const LoginPage(),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final currentIndex = (state is OnboardingPageState)
                ? state.index
                : 0;

            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingIllustration(index: index);
                  },
                ),

                Positioned(
                  top: 50,
                  right: 24,
                  child: TextButton(
                    onPressed: () {
                      context.read<OnboardingBloc>().add(SkipOnboarding());
                    },
                    child: Text(
                      'SKIP',
                      style: customisedStyle(
                        AppColors.white,
                        FontWeight.w600,
                        18.0,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 48,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PageIndicator(
                          count: _pages.length,
                          currentIndex: currentIndex,
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        Text(
                          _pages[currentIndex]['title']!,

                          style: customisedStyle(
                            AppColors.white,
                            FontWeight.w600,
                            28.0,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Text(
                          _pages[currentIndex]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        Row(
                          children: [
                            if (currentIndex > 0) ...[
                              InkWell(
                                onTap: () {
                                  context.read<OnboardingBloc>().add(
                                    PreviousPage(),
                                  );
                                },
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white.withOpacity(0.5),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.04),
                            ],
                            Expanded(
                              child: OnboardingButton(
                                text: _pages[currentIndex]['button']!,
                                onPressed: () {
                                  context.read<OnboardingBloc>().add(
                                    NextPage(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
