import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/achievement_service.dart';
import '../services/xp_service.dart';
import '../services/ai_feedback_service.dart';
import '../services/api_service.dart';

import '../services/grammar_checker_service.dart';

import 'speaking_result_screen.dart';
import 'grammar_result_screen.dart';

import 'package:flutter_tts/flutter_tts.dart';

import '../services/tts_service.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  final FlutterTts flutterTts = FlutterTts();

  late stt.SpeechToText speech;

  bool isListening = false;

  String spokenText = "";

  final TextEditingController controller = TextEditingController();

  final List<Map<String, String>> messages = [
    {
      "sender": "AI",
      "text": "Hello! 👋 How are you today?",
    },
  ];

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();

    TTSService.initialize();
  }


  @override
void dispose() {

  controller.dispose();

  speech.stop();

  flutterTts.stop();

  super.dispose();

}


  Future<void> startListening() async {
    print("Initializing speech...");
  bool available = await speech.initialize(
    onStatus: (status) {
      print("Speech Status: $status");
    },
    onError: (error) {
      print("Speech Error: $error");
    },
  );

  if (!available) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Speech recognition is not available.",
        ),
      ),
    );
    return;
  }

  setState(() {
    isListening = true;
  });

  speech.listen(
    listenFor: const Duration(seconds: 30),
    pauseFor: const Duration(seconds: 5),
    onResult: (result) async {
       print("Recognized: ${result.recognizedWords}");
      setState(() {
        // Convert speech to text
        spokenText = result.recognizedWords;

        // Show speech inside TextField
        controller.text = spokenText;
      });

      // Automatically send message when speech is complete
      if (result.finalResult) {
        await stopListening();

        if (controller.text.trim().isNotEmpty) {
          await sendMessage();
        }
      }
    },
  );
}

Future<void> stopListening() async {
  await speech.stop();

  if (!mounted) return;

  setState(() {
    isListening = false;
  });
}


Future<void> sendMessage() async {

  if (controller.text.trim().isEmpty) {
    return;
  }


  String userMessage = controller.text.trim();



  setState(() {

    messages.add({

      "sender": "You",

      "text": userMessage,

    });


    controller.clear();

  });



  // Show loading message

  setState(() {

    messages.add({

      "sender": "AI",

      "text": "Thinking...",

    });

  });



  // Call FastAPI backend

  String aiReply = await ApiService.sendMessage(

    userMessage,


  );



  // AI Voice Response 🔊

  await TTSService.speak(aiReply);



  setState(() {

    messages.removeLast();


    messages.add({

      "sender": "AI",

      "text": aiReply,

    });


  });


}

  Future<void> completeSpeakingPractice() async {
    // Save achievement
    await AchievementService.completeSpeakingPractice();

    // Add XP
    await XPService.addXP(10);

    // Show success message
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Speaking Practice Completed 🎤 +10 XP",
        ),
      ),
    );

    // Analyze speech
    final result = await AIFeedbackService.analyzeSpeech(
      spokenText,
    );


    // Open AI Feedback Screen
    // Open AI Feedback Screen
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeakingResultScreen(
          result: result,
        ),
      ),
    );
  }

  Future<void> checkGrammar() async {
    if (spokenText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please speak something first."),
        ),
      );
      return;
    }

    final result = GrammarCheckerService.check(spokenText);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GrammarResultScreen(
          result: result,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversation"),
        centerTitle: true,
      ),
      body: Column(
          children: [
      Expanded(
      child: ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        return Align(
          alignment: message["sender"] == "You"
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message["sender"] == "You"
                  ? Colors.blue
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message["text"]!,
              style: TextStyle(
                color: message["sender"] == "You"
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    ),
    ),



            if (spokenText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  spokenText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            SingleChildScrollView(

  scrollDirection: Axis.horizontal,

  child: Row(

    mainAxisAlignment: MainAxisAlignment.center,

    children: [

      FloatingActionButton(

        onPressed:
        isListening
            ? stopListening
            : startListening,

        child: Icon(

          isListening
              ? Icons.stop
              : Icons.mic,

        ),

      ),



      const SizedBox(width: 15),



      ElevatedButton(

        onPressed: completeSpeakingPractice,

        child: const Text(

          "Complete",

        ),

      ),



      const SizedBox(width: 15),



      ElevatedButton(

        onPressed: checkGrammar,

        child: const Text(

          "Grammar",

        ),

      ),


    ],

  ),

),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}











