import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

/// Service to manage up to 5 saved user profiles in SharedPreferences.
class UserProfileService {
  static const String _keyProfiles = 'saved_user_profiles_v1';
  static const String _keyActiveId = 'selected_user_profile_id_v1';

  final SharedPreferences _prefs;

  UserProfileService(this._prefs);

  /// Default 5 profile slots if none exist yet.
  static List<UserProfile> get defaultProfiles => [
        const UserProfile(id: '1', name: 'Person 1', dob: ''),
        const UserProfile(id: '2', name: 'Person 2', dob: ''),
        const UserProfile(id: '3', name: 'Person 3', dob: ''),
        const UserProfile(id: '4', name: 'Person 4', dob: ''),
        const UserProfile(id: '5', name: 'Person 5', dob: ''),
      ];

  /// Get list of saved user profiles.
  List<UserProfile> loadProfiles() {
    final rawJson = _prefs.getString(_keyProfiles);
    if (rawJson == null || rawJson.isEmpty) {
      return defaultProfiles;
    }
    try {
      final List decoded = jsonDecode(rawJson);
      final loaded = decoded.map((e) => UserProfile.fromJson(Map<String, dynamic>.from(e))).toList();
      // Ensure exactly 5 profiles exist
      while (loaded.length < 5) {
        final newId = '${loaded.length + 1}';
        loaded.add(UserProfile(id: newId, name: 'Person $newId', dob: ''));
      }
      return loaded.take(5).toList();
    } catch (_) {
      return defaultProfiles;
    }
  }

  /// Get currently active profile ID.
  String loadActiveProfileId() {
    return _prefs.getString(_keyActiveId) ?? '1';
  }

  /// Save profiles list and active profile ID.
  Future<void> saveProfiles(List<UserProfile> profiles, String activeId) async {
    final encoded = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await _prefs.setString(_keyProfiles, encoded);
    await _prefs.setString(_keyActiveId, activeId);
  }
}
