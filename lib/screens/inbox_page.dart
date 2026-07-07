import 'package:flutter/material.dart';

import '../data/inbox_mock_data.dart';
import '../models/inbox_message.dart';
import '../router.dart';
import '../widgets/common/platform_pull_to_refresh.dart';
import '../widgets/inbox/inbox_message_card.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List<InboxMessage> _messages = InboxMockData.messages;

  void _onProfileTap() {}

  Future<void> _onRefresh() async {
    final messages = await InboxMockData.refresh();
    if (!mounted) return;
    setState(() => _messages = messages);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _onProfileTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Text(
              'Inbox',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: PlatformPullToRefresh(
                onRefresh: _onRefresh,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList.separated(
                      itemCount: _messages.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return InboxMessageCard(
                          message: message,
                          onTap: () =>
                              AppRouter.openInboxDetail(context, message),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
