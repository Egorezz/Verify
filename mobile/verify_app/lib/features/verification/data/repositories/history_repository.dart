import 'package:dio/dio.dart';
import 'package:verify_app/features/auth/data/repositories/auth_repository.dart';

class HistoryRepository {
  final Dio _dio;
  final AuthRepository _authRepository;

  HistoryRepository(this._dio, this._authRepository);

  Future<List<Map<String, dynamic>>> getHistory() async {
    final token = await _authRepository.getAuthToken();
    if (token == null) {
      throw Exception('Пользователь не аутентифицирован');
    }

    final response = await _dio.get(
      '/history',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    throw Exception('Ошибка получения истории');
  }
}