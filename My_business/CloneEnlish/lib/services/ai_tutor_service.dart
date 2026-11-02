class AITutorService {


  static Future<String> getResponse(
      String userText
      ) async {


    await Future.delayed(
      const Duration(seconds: 1),
    );


    String text = userText.toLowerCase();



    if (text.contains("hello") ||
        text.contains("hi")) {


      return "Hello! Nice to meet you. Tell me about yourself.";

    }




    if (text.contains("my name")) {


      return "Great introduction! Can you also tell me where you live?";

    }





    if (text.contains("i am")) {


      return "Good sentence! Try adding more details to improve your fluency.";

    }





    if (text.contains("thank")) {


      return "You're welcome! Keep practicing every day.";

    }





    return "Good effort! Try speaking in complete sentences.";


  }


}