import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'mock_dio_interceptor.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'X-Api-Key': ApiConfig.apiKey,
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(MockDioInterceptor());
  return dio;
}
