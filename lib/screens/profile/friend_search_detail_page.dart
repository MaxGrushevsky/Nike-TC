import 'package:flutter/material.dart';

import '../../models/searchable_friend.dart';
import '../../services/blocked_friends_service.dart';
import '../../utils/safe_navigator.dart';

class FriendSearchDetailPage extends StatelessWidget {
  const FriendSearchDetailPage({super.key, required this.friend});

  final SearchableFriend friend;

  Future<void> _showActions(BuildContext context) async {
    final action = await showModalBottomSheet<_FriendAction>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Block',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                onTap: () => safePop(sheetContext, _FriendAction.block),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                onTap: () => safePop(sheetContext, _FriendAction.cancel),
              ),
            ],
          ),
        );
      },
    );

    if (action != _FriendAction.block || !context.mounted) {
      return;
    }

    await BlockedFriendsService.blockFriend(friend.id);
    if (!context.mounted) return;
    await safePop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name.toUpperCase()),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showActions(context),
            icon: const Icon(Icons.more_horiz),
            tooltip: 'More',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                friend.initials,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            friend.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            friend.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
          if (friend.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              friend.subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 32),
          const Divider(height: 1),
          const SizedBox(height: 24),
          _DetailRow(label: 'Email', value: friend.email),
          if (friend.hometown != null) ...[
            const SizedBox(height: 20),
            _DetailRow(label: 'Hometown', value: friend.hometown!),
          ],
          if (friend.bio != null) ...[
            const SizedBox(height: 20),
            _DetailRow(label: 'Bio', value: friend.bio!),
          ],
        ],
      ),
    );
  }
}

enum _FriendAction { block, cancel }

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
