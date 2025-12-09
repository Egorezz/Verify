import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_app/features/auth/bloc/auth_event.dart';
import 'package:verify_app/features/auth/bloc/auth_state.dart';
import 'package:verify_app/features/auth/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<ForgotPinEvent>(_onForgotPin);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.register(
        name: event.name,
        login: event.login,
        password: event.password,
        pin: event.pin,
      );
      if (success) {
        emit(AuthSuccess('Регистрация успешна'));
      } else {
        emit(AuthFailure('Ошибка регистрации'));
      }
    } catch (e) {
      emit(AuthFailure('Сетевая ошибка'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final isValid = await _authRepository.validatePin(event.pin);
    if (isValid) {
      emit(AuthSuccess('Успешный вход'));
    } else {
      emit(AuthFailure('Неверный PIN'));
    }
  }

  Future<void> _onForgotPin(
    ForgotPinEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.resetSession();
    emit(AuthInitial());
  }
}
