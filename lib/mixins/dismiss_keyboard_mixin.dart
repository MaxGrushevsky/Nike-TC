import 'package:flutter/material.dart';

mixin DismissKeyboardMixin<T extends StatefulWidget> on State<T> {
  void dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Widget wrapWithDismissKeyboard(Widget child) {
    return GestureDetector(
      onTap: dismissKeyboard,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
