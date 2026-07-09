import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/inbox_message.dart';

class InboxPersistenceService {
  InboxPersistenceService._();

  static const _openCountKey = 'inbox_open_count';
  static const _messagesKey = 'inbox_cached_messages';
  static const _dismissedIdsKey = 'inbox_dismissed_ids';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<int> incrementOpenCount() async {
    final prefs = await _prefs();
    final count = prefs.getInt(_openCountKey) ?? 0;
    final nextCount = count + 1;
    await prefs.setInt(_openCountKey, nextCount);
    return nextCount;
  }

  static Future<int> getOpenCount() async {
    final prefs = await _prefs();
    return prefs.getInt(_openCountKey) ?? 0;
  }

  static bool shouldShowPermissions(int openCount) {
    return openCount > 0 && openCount % 3 == 0;
  }

  static Future<void> saveMessages(List<InboxMessage> messages) async {
    final prefs = await _prefs();
    final encoded = jsonEncode(messages.map((message) => message.toJson()).toList());
    await prefs.setString(_messagesKey, encoded);
  }

  static Future<List<InboxMessage>?> loadMessages() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_messagesKey);
    if (raw == null) {
      return null;
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => InboxMessage.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<Set<String>> loadDismissedIds() async {
    final prefs = await _prefs();
    final ids = prefs.getStringList(_dismissedIdsKey) ?? const [];
    return ids.toSet();
  }

  static Future<void> addDismissedId(String id) async {
    final prefs = await _prefs();
    final ids = await loadDismissedIds()..add(id);
    await prefs.setStringList(_dismissedIdsKey, ids.toList());
  }
}
