import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}
