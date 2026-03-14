import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingPageState(0)) {
    on<NextPage>((event, emit) {
      if (state is OnboardingPageState) {
        final currentIndex = (state as OnboardingPageState).index;
        if (currentIndex < 2) {
          emit(OnboardingPageState(currentIndex + 1));
        } else {
          emit(OnboardingFinished());
        }
      }
    });

    on<PreviousPage>((event, emit) {
      if (state is OnboardingPageState) {
        final currentIndex = (state as OnboardingPageState).index;
        if (currentIndex > 0) {
          emit(OnboardingPageState(currentIndex - 1));
        }
      }
    });

    on<SkipOnboarding>((event, emit) {
      emit(OnboardingFinished());
    });

    on<FinishOnboarding>((event, emit) {
      emit(OnboardingFinished());
    });
  }
}
