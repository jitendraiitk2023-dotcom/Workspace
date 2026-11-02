import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';


class AchievementService {


  static const String lessonKey = "lessons_completed";
  static const String speakingKey = "speaking_completed";
  static const String vocabularyKey = "words_learned";



  // Increase lesson count
  static Future<void> completeLesson() async {

    final prefs = await SharedPreferences.getInstance();

    int count = prefs.getInt(lessonKey) ?? 0;

    count++;

    await prefs.setInt(
      lessonKey,
      count,
    );

  }




  // Increase speaking practice count
  static Future<void> completeSpeakingPractice() async {

    final prefs = await SharedPreferences.getInstance();

    int count = prefs.getInt(speakingKey) ?? 0;

    count++;

    await prefs.setInt(
      speakingKey,
      count,
    );

  }





  // Increase vocabulary count
  static Future<void> learnWord() async {

    final prefs = await SharedPreferences.getInstance();

    int count = prefs.getInt(vocabularyKey) ?? 0;

    count++;

    await prefs.setInt(
      vocabularyKey,
      count,
    );

  }





  // Get all achievements
  static Future<List<Achievement>> getAchievements() async {


    final prefs = await SharedPreferences.getInstance();



    int lessons =
        prefs.getInt(lessonKey) ?? 0;


    int speaking =
        prefs.getInt(speakingKey) ?? 0;


    int words =
        prefs.getInt(vocabularyKey) ?? 0;



    return [


      Achievement(

        title: "First Lesson",

        description:
        "Complete your first English lesson",

        icon: "🎯",

        unlocked: lessons >= 1,

      ),




      Achievement(

        title: "Speaking Star",

        description:
        "Complete 10 speaking practices",

        icon: "🎤",

        unlocked: speaking >= 1,

      ),




      Achievement(

        title: "Vocabulary Master",

        description:
        "Learn 100 new words",

        icon: "📚",

        unlocked: words >= 100,

      ),




      Achievement(

        title: "English Champion",

        description:
        "Complete 50 lessons",

        icon: "🏆",

        unlocked: lessons >= 50,

      ),


    ];

  }


}