import 'package:flutter/material.dart';

import '../mixins/dismiss_keyboard_mixin.dart';
import '../mixins/legal_links_mixin.dart';

abstract class AuthBasePage extends StatefulWidget {
  const AuthBasePage({super.key});
}

abstract class AuthBasePageState<T extends AuthBasePage> extends State<T>
    with DismissKeyboardMixin<T>, LegalLinksMixin<T> {
  String get headline;
  TextStyle get headlineStyle;
  Widget? get subtitle => null;

  double get spacingAfterHeadline => subtitle == null ? 32 : 12;

  double get spacingAfterSubtitle => 24;

  Widget buildForm(BuildContext context);

  @override
  void initState() {
    super.initState();
    initLegalLinks();
  }

  @override
  void dispose() {
    disposeLegalLinks();
    super.dispose();
  }

  Widget buildCloseButton(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: IconButton(
        icon: const Icon(Icons.close, size: 28),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithDismissKeyboard(
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    Image.asset('assets/images/nike.png', height: 24),
                    const SizedBox(height: 24),
                    Text(
                      headline,
                      textAlign: TextAlign.center,
                      style: headlineStyle,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 12),
                      subtitle!,
                      SizedBox(height: spacingAfterSubtitle),
                    ] else
                      SizedBox(height: spacingAfterHeadline),
                    buildForm(context),
                  ],
                ),
              ),
              buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
