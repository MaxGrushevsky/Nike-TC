import 'package:shared_preferences/shared_preferences.dart';

class BlockedFriendsService {
  BlockedFriendsService._();

  static const _blockedIdsKey = 'blocked_friend_ids';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<Set<String>> loadBlockedIds() async {
    final prefs = await _prefs();
    final values = prefs.getStringList(_blockedIdsKey) ?? const [];
    return values.toSet();
  }

  static Future<void> blockFriend(String friendId) async {
    final prefs = await _prefs();
    final blocked = await loadBlockedIds();
    blocked.add(friendId);
    await prefs.setStringList(_blockedIdsKey, blocked.toList());
  }

  static Future<bool> isBlocked(String friendId) async {
    final blocked = await loadBlockedIds();
    return blocked.contains(friendId);
  }
}
