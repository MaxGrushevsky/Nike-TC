import 'package:dio/dio.dart';

import '../config/api_config.dart';

Dio createDio() {
  return Dio(
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
}
