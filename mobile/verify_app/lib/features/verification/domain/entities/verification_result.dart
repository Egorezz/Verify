import 'package:equatable/equatable.dart';
import 'package:verify_app/features/verification/domain/enums/verification_status.dart';

class VerificationResult extends Equatable {
  final VerificationStatus status;

  const VerificationResult({required this.status});

  @override
  List<Object?> get props => [status];
}
