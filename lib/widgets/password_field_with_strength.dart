import 'package:flutter/material.dart';
import '../widgets/password_strength_bar.dart';
import '../widgets/auth_text_field.dart';

class PasswordFieldWithStrength extends StatelessWidget {
  const PasswordFieldWithStrength({
    super.key,
    required this.controller,
    required this.errorText,
    required this.onChanged,
    this.showStrengthBar = true,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final bool showStrengthBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthTextField(
          controller: controller,
          labelText: 'Password',
          errorText: errorText,
          obscureText: true,
          onChanged: onChanged,
        ),
        if (showStrengthBar) ...[
          const SizedBox(height: 8),
          PasswordStrengthBar(password: controller.text),
        ],
      ],
    );
  }
}
