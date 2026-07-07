import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void ensureWebViewPlatform() {
  if (kIsWeb || WebViewPlatform.instance != null) {
    return;
  }

  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  } else if (Platform.isIOS || Platform.isMacOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }
}

WebViewController createWebViewController() {
  ensureWebViewPlatform();

  late final PlatformWebViewControllerCreationParams params;
  if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,
      mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    );
  } else {
    params = const PlatformWebViewControllerCreationParams();
  }

  return WebViewController.fromPlatformCreationParams(params);
}
