import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class ProfilePersistenceService {
  ProfilePersistenceService._();

  static const _profileKey = 'user_profile';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<UserProfile> loadProfile() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_profileKey);
    if (raw == null) {
      return UserProfile.defaultProfile;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(json);
    } catch (_) {
      return UserProfile.defaultProfile;
    }
  }

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await _prefs();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }
}
