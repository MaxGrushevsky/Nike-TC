import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../router.dart';
import '../../services/profile_persistence_service.dart';
import '../../widgets/profile/avatar_picker_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfilePersistenceService.loadProfile();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _openEditProfile() async {
    final profile = _profile;
    if (profile == null) return;

    final updatedProfile = await AppRouter.openEditProfile(context, profile);
    if (updatedProfile == null || !mounted) return;

    await ProfilePersistenceService.saveProfile(updatedProfile);
    setState(() => _profile = updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final contentMaxWidth = constraints.maxWidth >= 700 ? 520.0 : 420.0;

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Column(
                        children: [
                          _buildTopBar(),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  buildAvatarImage(
                                    avatarPath: _profile!.avatarPath,
                                    radius: 56,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _profile!.uppercaseDisplayName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _OutlinedActionButton(
                                    label: 'EDIT PROFILE',
                                    onPressed: _openEditProfile,
                                  ),
                                  const SizedBox(height: 28),
                                  _QuickLinksRow(isWide: constraints.maxWidth >= 500),
                                  const SizedBox(height: 32),
                                  const Divider(height: 1),
                                  const SizedBox(height: 24),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'FRIENDS',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _OutlinedActionButton(
                                    label: 'ADD FRIENDS',
                                    onPressed: () {},
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              _profile!.memberSinceLabel,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 28),
          ),
        ],
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.grey.shade400),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _QuickLinksRow extends StatelessWidget {
  const _QuickLinksRow({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final children = [
      const _QuickLinkItem(icon: Icons.card_membership_outlined, label: 'Pass'),
      Container(
        width: 1,
        height: 56,
        color: Colors.grey.shade300,
      ),
      const _QuickLinkItem(icon: Icons.settings_outlined, label: 'Settings'),
    ];

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: children[0]),
          children[1],
          Expanded(child: children[2]),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: children[0]),
        children[1],
        Expanded(child: children[2]),
      ],
    );
  }
}

class _QuickLinkItem extends StatelessWidget {
  const _QuickLinkItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
