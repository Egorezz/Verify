import 'package:dio/dio.dart';
import 'package:verify_app/core/const/api_const.dart';
import 'package:verify_app/features/auth/data/repositories/auth_repository.dart';
import 'package:verify_app/features/verification/data/repositories/verification_repository.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

final authRepository = AuthRepository(dio);
final verificationRepository = VerificationRepository(dio, authRepository);
