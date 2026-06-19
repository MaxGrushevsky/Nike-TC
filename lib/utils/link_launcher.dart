import 'package:url_launcher/url_launcher.dart';
import 'app_links.dart';

class LinkLauncher {
  LinkLauncher._();

  static Future<void> openPrivacyPolicy() async {
    await launchUrl(
      AppLinks.privacyPolicy,
      mode: LaunchMode.externalApplication,
    );
  }

  static Future<void> openTermsOfUse() async {
    await launchUrl(AppLinks.termsOfUse, mode: LaunchMode.inAppWebView);
  }
}
