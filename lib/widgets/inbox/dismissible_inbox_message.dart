import 'package:flutter/material.dart';

import '../../models/inbox_message.dart';
import 'inbox_message_card.dart';

class DismissibleInboxMessage extends StatelessWidget {
  const DismissibleInboxMessage({
    super.key,
    required this.message,
    required this.onTap,
    required this.onDelete,
  });

  final InboxMessage message;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(message.id),
      direction: DismissDirection.endToStart,
      background: _DeleteBackground(),
      onDismissed: (_) => onDelete(),
      child: InboxMessageCard(
        message: message,
        onTap: onTap,
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
    );
  }
}
