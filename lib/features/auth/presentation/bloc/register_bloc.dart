import 'package:dio/dio.dart';
import 'package:field_track/core/utils/dio_error_message.dart';
import 'package:field_track/features/auth/domain/repositories/auth_repository.dart';
import 'package:field_track/features/auth/presentation/bloc/register_event.dart';
import 'package:field_track/features/auth/presentation/bloc/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository repository;

  RegisterBloc(this.repository) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading, errorMessage: null));

    try {
      await repository.register(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: RegisterStatus.success));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: dioErrorMessage(e, fallback: 'Could not create account'),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Something went wrong. Try again.',
      ));
    }
  }
}
