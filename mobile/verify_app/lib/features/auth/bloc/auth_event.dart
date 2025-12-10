abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String name, login, password, pin;
  RegisterEvent(this.name, this.login, this.password, this.pin);
}

class LoginEvent extends AuthEvent {
  final String pin;
  LoginEvent(this.pin);
}

class ForgotPinEvent extends AuthEvent {}

class SetNewPinEvent extends AuthEvent {
  final String pin;
  SetNewPinEvent(this.pin);
}

class VerifyCredentialsEvent extends AuthEvent {
  final String email;
  final String password;
  VerifyCredentialsEvent(this.email, this.password);
}
