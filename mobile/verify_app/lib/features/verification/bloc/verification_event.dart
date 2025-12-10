abstract class VerificationEvent {}

class VerifyDocumentEvent extends VerificationEvent {
  final String documentId;
  VerifyDocumentEvent({required this.documentId});
}

class VerifyImageEvent extends VerificationEvent {
  final String imagePath;
  VerifyImageEvent({required this.imagePath});
}

class ResetVerificationEvent extends VerificationEvent {}
