import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import 'package:verify_app/features/verification/bloc/verification_event.dart';
import 'package:verify_app/features/verification/bloc/verification_state.dart';
import 'package:verify_app/features/verification/data/repositories/verification_repository.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final VerificationRepository _repository;

  VerificationBloc(this._repository) : super(VerificationInitial()) {
    on<VerifyDocumentEvent>(_onVerify);
    on<VerifyImageEvent>(_onVerifyImage);
    on<ResetVerificationEvent>(_onReset);
  }

  Future<void> _onVerify(
    VerifyDocumentEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(VerificationLoading());
    try {
      final result = await _repository.verify(event.documentId, 'document');
      emit(VerificationSuccess(result.status));
    } catch (e) {
      emit(VerificationFailure('Ошибка сети'));
    }
  }

  Future<void> _onVerifyImage(
    VerifyImageEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(VerificationLoading());
    try {
      String? qrData;

      String processPath = event.imagePath;
      bool isPdf = event.imagePath.toLowerCase().endsWith('.pdf');

      if (isPdf) {
        emit(
          const VerificationFailure(
            'PDF файлы не поддерживаются. Используйте изображения.',
          ),
        );
        return;
      }

      final file = File(processPath);
      if (!await file.exists()) {
        emit(const VerificationFailure('Файл не найден'));
        return;
      }

      final inputImage = InputImage.fromFilePath(processPath);
      final barcodeScanner = BarcodeScanner(
        formats: [
          BarcodeFormat.qrCode,
          BarcodeFormat.dataMatrix,
          BarcodeFormat.all,
        ],
      );
      final barcodes = await barcodeScanner.processImage(inputImage);
      await barcodeScanner.close();

      if (barcodes.isEmpty) {
        emit(
          const VerificationFailure(
            'QR-код не найден. Попробуйте другое изображение с четким QR-кодом.',
          ),
        );
        return;
      }

      qrData = barcodes.first.rawValue;

      if (qrData == null || qrData.isEmpty) {
        emit(const VerificationFailure('Не удалось извлечь данные'));
        return;
      }

      final fileName = event.imagePath.split('/').last.split('\\').last;
      final docName = fileName.split('.').first;

      final result = await _repository.verify(qrData, docName);
      emit(VerificationSuccess(result.status));
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        emit(const VerificationFailure('Неверный формат ID документа'));
      } else if (e.response?.statusCode == 404) {
        emit(const VerificationFailure('Документ не найден в системе'));
      } else if (e.response?.statusCode == 401) {
        emit(const VerificationFailure('Ошибка авторизации'));
      } else {
        emit(VerificationFailure('Ошибка сервера: ${e.message}'));
      }
    } catch (e) {
      emit(VerificationFailure('Ошибка обработки: ${e.toString()}'));
    }
  }

  void _onReset(ResetVerificationEvent event, Emitter<VerificationState> emit) {
    emit(VerificationInitial());
  }
}
