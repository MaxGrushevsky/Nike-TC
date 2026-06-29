import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/link_launcher.dart';

mixin LegalLinksMixin<T extends StatefulWidget> on State<T> {
  late final TapGestureRecognizer privacyRecognizer;
  late final TapGestureRecognizer termsRecognizer;

  void initLegalLinks() {
    privacyRecognizer = TapGestureRecognizer()
      ..onTap = LinkLauncher.openPrivacyPolicy;
    termsRecognizer = TapGestureRecognizer()
      ..onTap = LinkLauncher.openTermsOfUse;
  }

  void disposeLegalLinks() {
    privacyRecognizer.dispose();
    termsRecognizer.dispose();
  }

  Widget buildLegalRichText({
    required String prefix,
    TextStyle? style,
  }) {
    final baseStyle = style ??
        TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
          height: 1.5,
        );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: prefix),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.grey,
            ),
            recognizer: privacyRecognizer,
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Terms of Use',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.grey,
            ),
            recognizer: termsRecognizer,
          ),
        ],
      ),
    );
  }
}
