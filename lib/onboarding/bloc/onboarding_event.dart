import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class NextPage extends OnboardingEvent {}

class PreviousPage extends OnboardingEvent {}

class SkipOnboarding extends OnboardingEvent {}

class FinishOnboarding extends OnboardingEvent {}
