import 'package:shared_preferences/shared_preferences.dart';

class XPService {
  static const String xpKey = "user_xp";

  static Future<int> getXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(xpKey) ?? 250;
  }

  static Future<void> addXP(int points) async {
    final prefs = await SharedPreferences.getInstance();

    int currentXP = prefs.getInt(xpKey) ?? 250;

    currentXP += points;

    await prefs.setInt(xpKey, currentXP);
  }

  static Future<void> resetXP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(xpKey, 250);
  }
}