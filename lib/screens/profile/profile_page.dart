import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/user_profile.dart';
import '../../redux/app_state.dart';
import '../../redux/profile/profile_actions.dart';
import '../../redux/profile/profile_state.dart';
import '../../router.dart';
import '../../utils/safe_navigator.dart';
import '../../widgets/profile/avatar_picker_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _openEditProfile(
    BuildContext context,
    UserProfile profile,
  ) async {
    final updatedProfile = await AppRouter.openEditProfile(context, profile);
    if (updatedProfile == null || !context.mounted) return;

    StoreProvider.of<AppState>(
      context,
    ).dispatch(SaveProfileAction(updatedProfile));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileState>(
      converter: (store) => store.state.profile,
      builder: (context, profileState) {
        final profile = profileState.profile;

        return Scaffold(
          body: SafeArea(
            child: profileState.isLoading || profile == null
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final contentMaxWidth =
                          constraints.maxWidth >= 700 ? 520.0 : 420.0;

                      return Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: contentMaxWidth),
                          child: Column(
                            children: [
                              _buildTopBar(context),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      buildAvatarImage(
                                        avatarPath: profile.avatarPath,
                                        radius: 56,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        profile.uppercaseDisplayName,
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
                                        onPressed: () =>
                                            _openEditProfile(context, profile),
                                      ),
                                      const SizedBox(height: 28),
                                      _QuickLinksRow(
                                        isWide: constraints.maxWidth >= 500,
                                        onPassTap: () =>
                                            AppRouter.openProfilePass(context),
                                        onSettingsTap: () =>
                                            AppRouter.openSettings(context),
                                      ),
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
                                        onPressed: () =>
                                            AppRouter.openFindFriends(context),
                                      ),
                                      const SizedBox(height: 32),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  profile.memberSinceLabel,
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
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          const Spacer(),
          IconButton(
            onPressed: () => safePop(context),
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
  const _QuickLinksRow({
    required this.isWide,
    required this.onPassTap,
    required this.onSettingsTap,
  });

  final bool isWide;
  final VoidCallback onPassTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final children = [
      _QuickLinkItem(
        icon: Icons.card_membership_outlined,
        label: 'Pass',
        onTap: onPassTap,
      ),
      Container(
        width: 1,
        height: 56,
        color: Colors.grey.shade300,
      ),
      _QuickLinkItem(
        icon: Icons.settings_outlined,
        label: 'Settings',
        onTap: onSettingsTap,
      ),
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
  const _QuickLinkItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
