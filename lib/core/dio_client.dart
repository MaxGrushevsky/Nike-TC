import 'package:dio/dio.dart';

import '../config/api_secrets.dart';

const _baseUrl = 'https://api.api-ninjas.com';

Dio createDio() {
  return Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'X-Api-Key': apiNinjasKey, 'Accept': 'application/json'},
    ),
  );
}
