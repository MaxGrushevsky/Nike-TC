import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../data/mock/activity_mock_data.dart';

bool get _isApplePlatform {
  if (kIsWeb) {
    return false;
  }
  return Platform.isIOS || Platform.isMacOS;
}

Future<String?> showActivityTypePicker(
  BuildContext context, {
  String? initialValue,
}) {
  if (_isApplePlatform) {
    return _showCupertinoListPicker(
      context,
      items: ActivityMockData.activityTypes,
      initialValue: initialValue,
    );
  }

  return showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: ActivityMockData.activityTypes.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final type = ActivityMockData.activityTypes[index];
            return ListTile(
              title: Text(type),
              trailing: initialValue == type ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, type),
            );
          },
        ),
      );
    },
  );
}

Future<DateTime?> showActivityDatePicker(
  BuildContext context, {
  required DateTime initialDateTime,
}) async {
  if (_isApplePlatform) {
    return _showCupertinoDatePicker(context, initialDateTime: initialDateTime);
  }

  final date = await showDatePicker(
    context: context,
    initialDate: initialDateTime,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (date == null || !context.mounted) {
    return null;
  }

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDateTime),
  );
  if (time == null) {
    return null;
  }

  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}

Future<Duration?> showActivityDurationPicker(
  BuildContext context, {
  required Duration initialDuration,
}) {
  if (_isApplePlatform) {
    return _showCupertinoDurationPicker(
      context,
      initialDuration: initialDuration,
    );
  }

  final initialMinutes = initialDuration.inMinutes.remainder(60);
  final initialHours = initialDuration.inHours;

  return showModalBottomSheet<Duration>(
    context: context,
    builder: (context) {
      var hours = initialHours;
      var minutes = initialMinutes;
      var seconds = initialDuration.inSeconds.remainder(60);

      return StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: hours,
                          decoration: const InputDecoration(labelText: 'HH'),
                          items: List.generate(
                            24,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text(index.toString().padLeft(2, '0')),
                            ),
                          ),
                          onChanged: (value) {
                            if (value == null) return;
                            setModalState(() => hours = value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: minutes,
                          decoration: const InputDecoration(labelText: 'mm'),
                          items: List.generate(
                            60,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text(index.toString().padLeft(2, '0')),
                            ),
                          ),
                          onChanged: (value) {
                            if (value == null) return;
                            setModalState(() => minutes = value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: seconds,
                          decoration: const InputDecoration(labelText: 'ss'),
                          items: List.generate(
                            60,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text(index.toString().padLeft(2, '0')),
                            ),
                          ),
                          onChanged: (value) {
                            if (value == null) return;
                            setModalState(() => seconds = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          Duration(hours: hours, minutes: minutes, seconds: seconds),
                        );
                      },
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<String?> _showCupertinoListPicker(
  BuildContext context, {
  required List<String> items,
  String? initialValue,
}) {
  var selectedIndex = initialValue == null
      ? 0
      : items.indexOf(initialValue).clamp(0, items.length - 1);

  return showCupertinoModalPopup<String>(
    context: context,
    builder: (context) {
      return Container(
        height: 320,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            _CupertinoSheetActions(
              onCancel: () => Navigator.pop(context),
              onDone: () => Navigator.pop(context, items[selectedIndex]),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: selectedIndex,
                ),
                itemExtent: 40,
                onSelectedItemChanged: (index) => selectedIndex = index,
                children: items.map((item) => Center(child: Text(item))).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<DateTime?> _showCupertinoDatePicker(
  BuildContext context, {
  required DateTime initialDateTime,
}) {
  var selectedDateTime = initialDateTime;

  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (context) {
      return Container(
        height: 320,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            _CupertinoSheetActions(
              onCancel: () => Navigator.pop(context),
              onDone: () => Navigator.pop(context, selectedDateTime),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: initialDateTime,
                onDateTimeChanged: (value) => selectedDateTime = value,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<Duration?> _showCupertinoDurationPicker(
  BuildContext context, {
  required Duration initialDuration,
}) {
  var selectedDuration = initialDuration;

  return showCupertinoModalPopup<Duration>(
    context: context,
    builder: (context) {
      return Container(
        height: 320,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            _CupertinoSheetActions(
              onCancel: () => Navigator.pop(context),
              onDone: () => Navigator.pop(context, selectedDuration),
            ),
            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: initialDuration,
                onTimerDurationChanged: (value) => selectedDuration = value,
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _CupertinoSheetActions extends StatelessWidget {
  const _CupertinoSheetActions({
    required this.onCancel,
    required this.onDone,
  });

  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(12),
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(12),
            onPressed: onDone,
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
