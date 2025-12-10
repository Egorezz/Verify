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
    on<SetNewPinEvent>(_onSetNewPin);
    on<VerifyCredentialsEvent>(_onVerifyCredentials);
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
    try {
      // Проверяем PIN локально
      final isPinValid = await _authRepository.validatePin(event.pin);
      if (!isPinValid) {
        emit(AuthFailure('Неверный PIN'));
        return;
      }
      
      // Проверяем есть ли токен
      final hasToken = await _authRepository.getAuthToken() != null;
      if (hasToken) {
        emit(AuthSuccess('Успешный вход'));
      } else {
        emit(AuthFailure('Необходима регистрация'));
      }
    } catch (e) {
      emit(AuthFailure('Ошибка сети'));
    }
  }

  Future<void> _onForgotPin(
    ForgotPinEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.resetSession();
    emit(AuthInitial());
  }

  Future<void> _onSetNewPin(
    SetNewPinEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.savePin(event.pin);
      emit(AuthSuccess('Новый PIN установлен'));
    } catch (e) {
      emit(AuthFailure('Ошибка сохранения PIN'));
    }
  }

  Future<void> _onVerifyCredentials(
    VerifyCredentialsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isValid = await _authRepository.verifyCredentials(
        event.email,
        event.password,
      );
      if (isValid) {
        emit(AuthSuccess('Учетные данные подтверждены'));
      } else {
        emit(AuthFailure('Неверные учетные данные'));
      }
    } catch (e) {
      emit(AuthFailure('Ошибка проверки данных'));
    }
  }
}
