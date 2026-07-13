import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/activity_item.dart';
import '../../utils/activity_formatters.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key, required this.activity});

  final ActivityItem activity;

  Future<void> _shareActivity(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;

    await SharePlus.instance.share(
      ShareParams(
        text: ActivityFormatters.shareMessage(activity),
        sharePositionOrigin: origin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.type),
        centerTitle: true,
        actions: [
          Builder(
            builder: (buttonContext) {
              return IconButton(
                onPressed: () => _shareActivity(buttonContext),
                icon: const Icon(Icons.ios_share),
                tooltip: 'Share activity',
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.bar_chart, color: Colors.white, size: 44),
            ),
          ),
          const SizedBox(height: 32),
          _DetailRow(
            label: 'Activity Type',
            value: activity.type,
          ),
          const Divider(height: 32),
          _DetailRow(
            label: 'Date',
            value: ActivityFormatters.detailDateLabel(activity.dateTime),
          ),
          const Divider(height: 32),
          _DetailRow(
            label: 'Duration',
            value: ActivityFormatters.durationLabel(activity.duration),
          ),
          const Divider(height: 32),
          _DetailRow(
            label: 'Total Minutes',
            value: '${activity.durationInMinutes}',
          ),
        ],
      ),
    );
  }
}

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
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
