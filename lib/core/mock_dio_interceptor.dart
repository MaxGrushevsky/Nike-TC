import 'package:dio/dio.dart';

import '../data/mock/mock_data_config.dart';
import '../data/mock/workouts_mock_data.dart';

class MockDioInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (!MockDataConfig.shouldUseMockData) {
      handler.next(options);
      return;
    }

    if (options.path != '/v1/exercises') {
      handler.next(options);
      return;
    }

    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: WorkoutsMockData.exercisesFor(
          muscle: options.queryParameters['muscle'] as String?,
          type: options.queryParameters['type'] as String?,
          difficulty: options.queryParameters['difficulty'] as String?,
        ),
      ),
    );
  }
}
