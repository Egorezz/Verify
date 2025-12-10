import 'package:equatable/equatable.dart';
import 'package:verify_app/features/verification/domain/enums/verification_status.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();
}

class VerificationInitial extends VerificationState {
  @override
  List<Object?> get props => [];
}

class VerificationLoading extends VerificationState {
  @override
  List<Object?> get props => [];
}

class VerificationSuccess extends VerificationState {
  final VerificationStatus status;
  const VerificationSuccess(this.status);
  @override
  List<Object?> get props => [status];
}

class VerificationFailure extends VerificationState {
  final String error;
  const VerificationFailure(this.error);
  @override
  List<Object?> get props => [error];
}
