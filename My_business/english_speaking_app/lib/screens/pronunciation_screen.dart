import 'package:flutter/material.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {

  final List<String> words = [
    "Apple",
    "Beautiful",
    "Opportunity",
    "Environment",
    "Confidence",
    "Communication",
  ];

  int currentWord = 0;

  void nextWord() {
    setState(() {
      if (currentWord < words.length - 1) {
        currentWord++;
      } else {
        currentWord = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pronunciation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Speak this word",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            Text(
              words[currentWord],
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 60),

            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.mic,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: nextWord,
              child: const Text("Next Word"),
            ),
          ],
        ),
      ),
    );
  }
}