import 'package:dio/dio.dart';
import 'package:field_track/core/utils/dio_error_message.dart';
import 'package:field_track/features/auth/domain/repositories/auth_repository.dart';
import 'package:field_track/features/auth/presentation/bloc/login_event.dart';
import 'package:field_track/features/auth/presentation/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc(this.repository) : super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      await repository.login(email: event.email, password: event.password);
      emit(state.copyWith(status: LoginStatus.success));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: dioErrorMessage(e, fallback: 'Invalid email or password'),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Something went wrong. Try again.',
      ));
    }
  }
}
