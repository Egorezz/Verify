import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:verify_app/core/const/api_const.dart';

final secureStorage = FlutterSecureStorage();

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: Duration(seconds: ApiConstants.requestTimeoutSeconds),
    receiveTimeout: Duration(seconds: ApiConstants.requestTimeoutSeconds),
  ),
);
