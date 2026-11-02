import 'package:shared_preferences/shared_preferences.dart';


class StreakService {

  static const String streakKey = "current_streak";
  static const String lastDateKey = "last_open_date";


  // Get saved streak
  static Future<int> getStreak() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(streakKey) ?? 0;

  }



  // Update streak when app opens
  static Future<int> updateStreak() async {


    final prefs = await SharedPreferences.getInstance();


    int streak = prefs.getInt(streakKey) ?? 0;


    String? lastDate =
    prefs.getString(lastDateKey);



    String today =
    DateTime.now()
        .toIso8601String()
        .substring(0,10);



    // First app opening
    if(lastDate == null) {

      streak = 1;

    }


    else {


      DateTime previousDate =
      DateTime.parse(lastDate);


      DateTime currentDate =
      DateTime.parse(today);



      int difference =
          currentDate
              .difference(previousDate)
              .inDays;



      // User opened app next day
      if(difference == 1) {

        streak++;

      }


      // User missed a day
      else if(difference > 1) {

        streak = 1;

      }


      // Same day
      else {

        streak = streak;

      }


    }



    await prefs.setInt(
      streakKey,
      streak,
    );


    await prefs.setString(
      lastDateKey,
      today,
    );


    return streak;

  }


}