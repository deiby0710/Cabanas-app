import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _orgKey = 'orgId';

  Future<void> saveOrgId(String orgId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_orgKey, orgId);
  }

  Future<String?> getOrgId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_orgKey);
  }

  Future<void> clearOrgId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_orgKey);
  }
}