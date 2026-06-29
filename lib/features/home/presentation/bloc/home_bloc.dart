import 'package:field_track/features/auth/domain/repositories/auth_repository.dart';
import 'package:field_track/features/home/presentation/bloc/home_event.dart';
import 'package:field_track/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository repository;

  HomeBloc(this.repository) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeLogoutRequested>(_onLogout);
  }

  Future<void> _onStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final user = await repository.getCurrentUser();
      emit(state.copyWith(status: HomeStatus.loaded, user: user));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onLogout(
    HomeLogoutRequested event,
    Emitter<HomeState> emit,
  ) async {
    await repository.logout();
    emit(state.copyWith(loggedOut: true));
  }
}
