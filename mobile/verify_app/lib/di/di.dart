// lib/di/di.dart
import 'package:dio/dio.dart';
import 'package:verify_app/core/const/api_const.dart';
import 'package:verify_app/features/auth/data/repositories/auth_repository.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ),
);

// Теперь передаём dio в AuthRepository
final authRepository = AuthRepository(dio);
