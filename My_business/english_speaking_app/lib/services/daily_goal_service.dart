import 'package:shared_preferences/shared_preferences.dart';

class DailyGoalService {
  static const String _todayXPKey = "today_xp";
  static const String _dateKey = "goal_date";

  static Future<void> addTodayXP(int xp) async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(_dateKey);

    if (savedDate != today) {
      await prefs.setString(_dateKey, today);
      await prefs.setInt(_todayXPKey, 0);
    }

    int currentXP = prefs.getInt(_todayXPKey) ?? 0;
    currentXP += xp;

    await prefs.setInt(_todayXPKey, currentXP);
  }

  static Future<int> getTodayXP() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(_dateKey);

    if (savedDate != today) {
      await prefs.setString(_dateKey, today);
      await prefs.setInt(_todayXPKey, 0);
      return 0;
    }

    return prefs.getInt(_todayXPKey) ?? 0;
  }
}