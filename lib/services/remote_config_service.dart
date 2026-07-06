import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService instance = RemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static const welcomePromoTextKey = 'welcome_promo_text';

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.setDefaults(const {
      welcomePromoTextKey: '',
    });

    try {
      await _remoteConfig.fetchAndActivate();
    } on FirebaseException {
      // Defaults are used when fetch fails (offline, etc.).
    }
  }

  String get welcomePromoText => _remoteConfig.getString(welcomePromoTextKey);
}
