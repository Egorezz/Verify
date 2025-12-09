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
            // Принимаем 200 и 400 (чтобы обработать ошибки вручную)
            return status == 200 || status == 400;
          },
        ),
      );

      // 🔑 Ключевое: сначала смотрим на статус
      if (response.statusCode == 200) {
        // Успех: тело = "Success"
        if (response.data == "Success") {
          // Продолжаем на вход
        } else {
          print('Неожиданный ответ при 200: ${response.data}');
          return false;
        }
      } else if (response.statusCode == 400) {
        // Ошибка валидации: дубль email/логина
        final message = response.data is String
            ? response.data
            : 'Ошибка регистрации';
        print('Ошибка от сервера: $message');
        // Можно показать пользователю: ScaffoldMessenger.of(...).showSnackBar(Text(message));
        return false;
      } else {
        print('Неожиданный статус: ${response.statusCode}');
        return false;
      }

      // ---- Вход для получения JWT ----
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
          // Сохраняем всё
          final pinHash = PinHasher.hash(pin);
          await _storage.write(key: _keyPinHash, value: pinHash);
          await _storage.write(key: _keyJwtToken, value: jwtToken);
          await _storage.write(key: _keyName, value: name);
          await _storage.write(key: _keyLogin, value: login);
          await _storage.write(key: _keyIsRegistered, value: 'true');
          print(_storage);
          return true;
        }
      } else if (signinResponse.statusCode == 401) {
        print('Неверный пароль при входе');
      }
      return false;
    } catch (e, stack) {
      print('❌ Сетевая ошибка: $e\n$stack');
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
}
