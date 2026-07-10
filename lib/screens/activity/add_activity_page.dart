import 'package:flutter/material.dart';

import '../../models/activity_item.dart';
import '../../widgets/activity/activity_form_pickers.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  String? _activityType;
  DateTime _dateTime = DateTime.now();
  Duration _duration = const Duration(minutes: 30);

  bool get _canSubmit => _activityType != null;

  Future<void> _pickActivityType() async {
    final type = await showActivityTypePicker(
      context,
      initialValue: _activityType,
    );
    if (type == null || !mounted) return;
    setState(() => _activityType = type);
  }

  Future<void> _pickDate() async {
    final dateTime = await showActivityDatePicker(
      context,
      initialDateTime: _dateTime,
    );
    if (dateTime == null || !mounted) return;
    setState(() => _dateTime = dateTime);
  }

  Future<void> _pickDuration() async {
    final duration = await showActivityDurationPicker(
      context,
      initialDuration: _duration,
    );
    if (duration == null || !mounted) return;
    setState(() => _duration = duration);
  }

  void _submit() {
    if (!_canSubmit) return;

    Navigator.pop(
      context,
      ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _activityType!,
        dateTime: _dateTime,
        duration: _duration,
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = weekdays[dateTime.weekday - 1];
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final isToday = _isToday(dateTime);

    if (isToday) {
      return 'Today / $hour:$minute';
    }

    return '$weekday, ${dateTime.day} ${_monthLabel(dateTime.month)} $hour:$minute';
  }

  bool _isToday(DateTime dateTime) {
    final now = DateTime.now();
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }

  String _monthLabel(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Activity'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _FormRow(
                  label: 'Activity Type',
                  value: _activityType ?? 'Select',
                  isPlaceholder: _activityType == null,
                  onTap: _pickActivityType,
                ),
                const Divider(height: 1),
                _FormRow(
                  label: 'Date',
                  value: _formatDate(_dateTime),
                  onTap: _pickDate,
                ),
                const Divider(height: 1),
                _FormRow(
                  label: 'Duration',
                  value: _formatDuration(_duration),
                  onTap: _pickDuration,
                ),
              ],
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isPlaceholder ? Colors.grey.shade500 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
