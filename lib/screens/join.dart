import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../widgets/auth_text_field.dart';
import 'login.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _firstNameError;
  String? _lastNameError;
  String? _dobError;

  String? _selectedCountry = 'Belarus';
  bool _emailOptIn = false;

  bool get _isButtonEnabled {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _dobController.text.trim().isNotEmpty;
  }

  double get _buttonOpacity => _isButtonEnabled ? 1.0 : 0.5;

  void _onJoinUs() {
    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = Validators.email(_emailController.text);
      _passwordError = Validators.joinPassword(_passwordController.text);
      _firstNameError = Validators.firstName(_firstNameController.text);
      _lastNameError = Validators.lastName(_lastNameController.text);
      _dobError = Validators.dateOfBirth(_dobController.text);
    });

    if (_emailError == null &&
        _passwordError == null &&
        _firstNameError == null &&
        _lastNameError == null &&
        _dobError == null) {
    }
  }

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
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
                      'BECOME A NIKE\nMEMBER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your Nike Member profile and get first access to the very best of Nike products, inspiration and community.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

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
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) {
                        setState(() {
                          if (_passwordError != null) _passwordError = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _firstNameController,
                      labelText: 'First Name',
                      errorText: _firstNameError,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) {
                        setState(() {
                          if (_firstNameError != null) _firstNameError = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _lastNameController,
                      labelText: 'Last Name',
                      errorText: _lastNameError,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) {
                        setState(() {
                          if (_lastNameError != null) _lastNameError = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _dobController,
                      labelText: 'Date of Birth',
                      errorText: _dobError,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) {
                        setState(() {
                          if (_dobError != null) _dobError = null;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get a Nike Member Reward every year on your Birthday.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedCountry,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Belarus',
                          child: Text('Belarus'),
                        ),
                        DropdownMenuItem(
                          value: 'Poland',
                          child: Text('Poland'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedCountry = value);
                      },
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _emailOptIn,
                          onChanged: (value) {
                            setState(() => _emailOptIn = value ?? false);
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Sign up for emails to get updates from Nike on products, offers, workout guidance and your Member benefits',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
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
                        children: const [
                          TextSpan(
                            text: 'By creating an account, you agree to\n',
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Terms of Use',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        onPressed: _isButtonEnabled ? _onJoinUs : null,
                        child: const Text(
                          'JOIN US',
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
                          const TextSpan(text: 'Already a Member? '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: _openLogin,
                              child: const Text(
                                'Sign In.',
                                style: TextStyle(
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
