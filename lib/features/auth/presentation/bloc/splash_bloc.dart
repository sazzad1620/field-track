import 'package:field_track/features/auth/domain/repositories/auth_repository.dart';
import 'package:field_track/features/auth/presentation/bloc/splash_event.dart';
import 'package:field_track/features/auth/presentation/bloc/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository repository;

  SplashBloc(this.repository) : super(const SplashState()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(status: SplashStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 600));

    try {
      final isValid = await repository.validateSession();
      emit(state.copyWith(
        status: isValid
            ? SplashStatus.authenticated
            : SplashStatus.unauthenticated,
      ));
    } catch (_) {
      emit(state.copyWith(status: SplashStatus.unauthenticated));
    }
  }
}
