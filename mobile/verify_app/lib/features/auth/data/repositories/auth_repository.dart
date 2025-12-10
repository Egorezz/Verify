import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:verify_app/core/security/pin_hasher.dart';

class AuthRepository {
  static const String _keyIsRegistered = 'is_registered';
  static const String _keyPinHash = 'pin_hash';
  static const String _keyJwtToken = 'jwt_token';
  static const String _keyName = 'user_name';
  static const String _keyLogin = 'user_login';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio;

  AuthRepository(this._dio);

  Future<bool> register({
    required String name,
    required String login,
    required String password,
    required String pin,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {
          'username': name,
          'email': login,
          'password': password,
          'pin': pin,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) {
            return status == 200 || status == 400;
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == "Success") {
        } else {
          return false;
        }
      } else if (response.statusCode == 400) {
        final message = response.data is String
            ? response.data
            : 'Ошибка регистрации';
        print('Ошибка от сервера: $message');
        return false;
      } else {
        return false;
      }

      final signinResponse = await _dio.post(
        '/auth/signin',
        data: {'username': name, 'pin': pin},
        options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => status == 200 || status == 401,
        ),
      );

      if (signinResponse.statusCode == 200) {
        final jwtToken = signinResponse.data;
        if (jwtToken is String) {
          final pinHash = PinHasher.hash(pin);
          await _storage.write(key: _keyPinHash, value: pinHash);
          await _storage.write(key: _keyJwtToken, value: jwtToken);
          await _storage.write(key: _keyName, value: name);
          await _storage.write(key: _keyLogin, value: login);
          await _storage.write(key: _keyIsRegistered, value: 'true');
          return true;
        }
      } else if (signinResponse.statusCode == 401) {
        print('Неверный пароль при входе');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validatePin(String inputPin) async {
    final storedHash = await _storage.read(key: _keyPinHash);
    if (storedHash == null) return false;
    return PinHasher.verify(inputPin, storedHash);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyJwtToken);
  }

  Future<void> resetSession() async {
    await _storage.deleteAll();
  }

  Future<bool> isRegistered() async {
    return await _storage.read(key: _keyIsRegistered) == 'true';
  }

  Future<String?> getUserId() async {
    final token = await getAuthToken();
    if (token == null) return null;

    try {
      final response = await _dio.get(
        '/secured/id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final userId = response.data;
        return userId?.toString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> savePin(String pin) async {
    final pinHash = PinHasher.hash(pin);
    await _storage.write(key: _keyPinHash, value: pinHash);
  }

  Future<bool> verifyCredentials(String email, String password) async {
    try {
      print('Начало проверки учетных данных');

      // Получаем сохраненные данные текущего пользователя
      final savedEmail = await _storage.read(key: _keyLogin);
      final token = await getAuthToken();

      print('Сохраненный email: $savedEmail');
      print('Введенный email: $email');
      print('Токен есть: ${token != null}');

      if (savedEmail == null || token == null) {
        print('Ошибка: нет сохраненных данных');
        return false;
      }

      // Проверяем, что email совпадает с текущим пользователем
      if (savedEmail != email) {
        print('Ошибка: email не совпадает');
        return false;
      }

      print('Отправляем запрос на /auth/change-pin');

      // Проверяем email и пароль на backend
      final response = await _dio.get(
        '/auth/change-pin',
        data: {'email': email, 'password': password},
        options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => status == 200 || status == 401,
        ),
      );

      print('Ответ сервера: ${response.statusCode}');
      print('Данные ответа: ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      print('Ошибка в verifyCredentials: $e');
      return false;
    }
  }

  Future<bool> validateToken() async {
    final token = await getAuthToken();
    if (token == null) return false;

    try {
      final response = await _dio.get(
        '/secured/validate',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status == 200 || status == 401,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getSavedEmail() async {
    return await _storage.read(key: _keyLogin);
  }
}
