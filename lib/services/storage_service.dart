import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class StorageService {
  static const _profileKey = 'user_profile';

  final SharedPreferences prefs;

  StorageService(this.prefs);

  Future<UserProfile> loadUserProfile() async {
    final raw = prefs.getString(_profileKey);
    if (raw == null || raw.isEmpty) {
      return const UserProfile();
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return const UserProfile();
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }
}
