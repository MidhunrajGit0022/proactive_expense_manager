import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingPageState extends OnboardingState {
  final int index;

  const OnboardingPageState(this.index);

  @override
  List<Object?> get props => [index];
}

class OnboardingFinished extends OnboardingState {}
