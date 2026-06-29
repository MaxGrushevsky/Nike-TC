import 'package:flutter/material.dart';

import '../base/auth_base_page.dart';
import '../router.dart';
import '../utils/validators.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends AuthBasePage {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends AuthBasePageState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool get _isButtonEnabled {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  double get _buttonOpacity => _isButtonEnabled ? 1.0 : 0.5;

  @override
  String get headline => 'YOUR ACCOUNT FOR\nEVERYTHING NIKE';

  @override
  TextStyle get headlineStyle => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        height: 1.4,
      );

  void _onSignIn() {
    dismissKeyboard();

    setState(() {
      _emailError = Validators.email(_emailController.text);
      _passwordError = Validators.loginPassword(_passwordController.text);
    });

    if (_emailError == null && _passwordError == null) {
      AppRouter.replaceWithDashboard(context);
    }
  }

  @override
  Widget buildForm(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: _emailController,
          labelText: 'Email address',
          errorText: _emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            setState(() {
              if (_emailError != null) _emailError = null;
            });
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          labelText: 'Password',
          errorText: _passwordError,
          textInputAction: TextInputAction.next,
          obscureText: true,
          onChanged: (_) {
            setState(() {
              if (_passwordError != null) _passwordError = null;
            });
          },
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Forgotten your password?',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        buildLegalRichText(prefix: 'By logging in, you agree to\n'),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: _buttonOpacity),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.black.withValues(alpha: 0.5),
              disabledForegroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            onPressed: _isButtonEnabled ? _onSignIn : null,
            child: const Text(
              'SIGN IN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
            children: const [
              TextSpan(text: 'Not a Member? '),
              TextSpan(
                text: 'Join Us.',
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
