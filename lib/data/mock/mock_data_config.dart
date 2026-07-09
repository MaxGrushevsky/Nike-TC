import '../../config/api_config.dart';

class MockDataConfig {
  MockDataConfig._();

  static const useMockData = bool.fromEnvironment('USE_MOCK_DATA');

  static bool get shouldUseMockData => useMockData || ApiConfig.apiKey.isEmpty;
}
