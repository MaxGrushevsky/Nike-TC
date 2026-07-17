import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../utils/safe_navigator.dart';
import '../router.dart';
import '../utils/auth_errors.dart';
import '../utils/validators.dart';
import '../utils/link_launcher.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _authError;
  bool _isLoading = false;

  bool get _isButtonEnabled {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  double get _buttonOpacity => _isButtonEnabled ? 1.0 : 0.5;

  Future<void> _onSignIn() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = Validators.email(_emailController.text);
      _passwordError = Validators.loginPassword(_passwordController.text);
      _authError = null;
    });

    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await FirebaseAnalytics.instance.logLogin(loginMethod: 'email');

      if (!mounted) return;
      AppRouter.replaceWithDashboard(context);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() => _authError = authErrorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openJoin() {
    AppRouter.openJoin(context);
  }

  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _termsRecognizer;

  @override
  void initState() {
    super.initState();
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = LinkLauncher.openPrivacyPolicy;
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = LinkLauncher.openTermsOfUse;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
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
                    const Text(
                      'YOUR ACCOUNT FOR\nEVERYTHING NIKE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

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

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'By logging in, you agree to\n'),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.grey,
                            ),
                            recognizer: _privacyRecognizer,
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Terms of Use',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.grey,
                            ),
                            recognizer: _termsRecognizer,
                          ),
                        ],
                      ),
                    ),
                    if (_authError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _authError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withValues(
                            alpha: _buttonOpacity,
                          ),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.black.withValues(
                            alpha: 0.5,
                          ),
                          disabledForegroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isButtonEnabled && !_isLoading
                            ? _onSignIn
                            : null,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
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
                        children: [
                          const TextSpan(text: 'Not a Member? '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: _openJoin,
                              child: const Text(
                                'Join Us.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () => safePopOrWelcome(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _privacyRecognizer.dispose();
    _termsRecognizer.dispose();
    super.dispose();
  }
}
