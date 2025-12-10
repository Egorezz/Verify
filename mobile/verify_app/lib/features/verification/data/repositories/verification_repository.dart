import 'package:dio/dio.dart';
import 'package:verify_app/core/utils/exponential_backoff.dart';
import 'package:verify_app/features/auth/data/repositories/auth_repository.dart';
import 'package:verify_app/features/verification/domain/entities/verification_result.dart';
import 'package:verify_app/features/verification/domain/entities/document_history_item.dart';
import 'package:verify_app/features/verification/domain/enums/verification_status.dart';

class VerificationRepository {
  final Dio _dio;
  final AuthRepository _authRepository;

  VerificationRepository(this._dio, this._authRepository);

  Future<VerificationResult> verify(String documentId, String docName) async {
    return retryWithExponentialBackoff(() async {
      final token = await _authRepository.getAuthToken();
      if (token == null) {
        throw Exception('Пользователь не аутентифицирован');
      }

      final id = int.tryParse(documentId);
      if (id == null) {
        throw Exception('QR содержит: "$documentId" (не число)');
      }
      final idStr = documentId;

      final userId = await _authRepository.getUserId();
      if (userId == null) {
        throw Exception('Не удалось получить ID пользователя');
      }

      final url = '/document/verify/$idStr/user/$userId/docName/$docName';
      print('Отправляем запрос: $url');

      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 404) {
        throw Exception('Документ не найден в системе');
      } else if (response.statusCode == 401) {
        throw Exception('Ошибка авторизации');
      } else if (response.statusCode == 400) {
        throw Exception('Неверный формат запроса');
      } else if (response.statusCode != 200) {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }

      final data = response.data;

      String statusStr;
      if (data is String) {
        statusStr = data.toUpperCase();
      } else if (data is Map) {
        statusStr = data['status'] ?? 'INVALID';
      } else {
        statusStr = 'INVALID';
      }

      print('Статус QR кода от сервера: $statusStr');

      VerificationStatus status;
      switch (statusStr) {
        case 'VALID':
          status = VerificationStatus.valid;
          break;
        case 'EXPIRING_SOON':
          status = VerificationStatus.expiringSoon;
          break;
        default:
          status = VerificationStatus.invalid;
      }

      return VerificationResult(status: status);
    });
  }

  Future<List<DocumentHistoryItem>> getHistory() async {
    final token = await _authRepository.getAuthToken();
    if (token == null) {
      throw Exception('Пользователь не аутентифицирован');
    }

    final userId = await _authRepository.getUserId();
    if (userId == null) {
      throw Exception('Не удалось получить ID пользователя');
    }

    final url = '/document/verified/$userId';
    print('Запрос истории: $url');
    
    final response = await _dio.get(
      url,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );
    
    if (response.statusCode == 404) {
      throw Exception('Эндпоинт истории не найден');
    } else if (response.statusCode == 401) {
      throw Exception('Ошибка авторизации');
    } else if (response.statusCode != 200) {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }

    final List<dynamic> data = response.data;
    return data.map((json) => DocumentHistoryItem.fromJson(json)).toList();
  }
}
