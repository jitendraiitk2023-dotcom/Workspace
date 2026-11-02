import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _nameKey = "name";
  static const String _emailKey = "email";
  static const String _goalKey = "goal";

  // Save Name
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  // Get Name
  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? "Guest";
  }

  // Save Email
  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  // Get Email
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ??
        "guest@email.com";
  }

  // Save Goal
  static Future<void> saveGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalKey, goal);
  }

  // Get Goal
  static Future<String> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_goalKey) ??
        "Speak English Fluently";
  }
}