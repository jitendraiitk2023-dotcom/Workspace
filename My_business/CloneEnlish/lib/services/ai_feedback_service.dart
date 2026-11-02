import '../models/speaking_result.dart';


class AIFeedbackService {


  static Future<SpeakingResult> analyzeSpeech(
      String text
      ) async {


    await Future.delayed(
      const Duration(seconds: 2),
    );


    return SpeakingResult(

      pronunciationScore: 85,

      grammarScore: 80,

      fluency: "Good",

      feedback:
      "Your speaking is clear. Keep practicing every day.",

      correction:
      text.isEmpty
          ? "Please speak a complete sentence."
          : text,

    );


  }


}