import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../models/user_profile.dart';
import '../../services/profile_persistence_service.dart';

class ProfilePassPage extends StatefulWidget {
  const ProfilePassPage({super.key});

  @override
  State<ProfilePassPage> createState() => _ProfilePassPageState();
}

class _ProfilePassPageState extends State<ProfilePassPage> {
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _setMaxBrightness();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfilePersistenceService.loadProfile();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _setMaxBrightness() async {
    try {
      await ScreenBrightness.instance.setApplicationScreenBrightness(1.0);
    } catch (_) {}
  }

  Future<void> _restoreBrightness() async {
    try {
      await ScreenBrightness.instance.resetApplicationScreenBrightness();
    } catch (_) {}
  }

  @override
  void dispose() {
    unawaited(_restoreBrightness());
    super.dispose();
  }

  String _passCode(UserProfile profile) {
    final memberId = profile.displayName.replaceAll(' ', '-').toUpperCase();
    return 'NIKE-TC-PASS:$memberId:${profile.memberSince.year}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          unawaited(_restoreBrightness());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'PASS',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final cardMaxWidth = constraints.maxWidth >= 700 ? 420.0 : 340.0;

                  return Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: cardMaxWidth),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Text(
                                    _profile!.uppercaseDisplayName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _profile!.memberSinceLabel,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  QrImageView(
                                    data: _passCode(_profile!),
                                    version: QrVersions.auto,
                                    size: 220,
                                    backgroundColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey.shade700,
                                ),
                                children: const [
                                  TextSpan(
                                    text:
                                        'Check in easily and get personalised service at Nike stores and events. ',
                                  ),
                                  TextSpan(
                                    text: 'Learn more.',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
