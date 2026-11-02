import 'package:flutter/material.dart';

class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> grammarTopics = [
      {
        "title": "Present Simple",
        "rule": "Used for daily habits and facts.",
        "example": "I go to school every day."
      },
      {
        "title": "Present Continuous",
        "rule": "Used for actions happening now.",
        "example": "I am reading a book."
      },
      {
        "title": "Past Simple",
        "rule": "Used for completed actions.",
        "example": "I visited Delhi yesterday."
      },
      {
        "title": "Future Simple",
        "rule": "Used for future actions.",
        "example": "I will call you tomorrow."
      },
      {
        "title": "Articles (A, An, The)",
        "rule": "Used before nouns.",
        "example": "I have an apple."
      },
      {
        "title": "Prepositions",
        "rule": "Show position or direction.",
        "example": "The book is on the table."
      },
      {
        "title": "Subject-Verb Agreement",
        "rule": "Verb should match the subject.",
        "example": "She plays cricket."
      },
      {
        "title": "Question Formation",
        "rule": "Use helping verbs for questions.",
        "example": "Do you like coffee?"
      },
      {
        "title": "Active Voice",
        "rule": "Subject performs the action.",
        "example": "Ram wrote a letter."
      },
      {
        "title": "Passive Voice",
        "rule": "Subject receives the action.",
        "example": "A letter was written by Ram."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grammar Lessons"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: grammarTopics.length,
        itemBuilder: (context, index) {
          final topic = grammarTopics[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic["title"]!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Rule:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(topic["rule"]!),
                  const SizedBox(height: 10),
                  Text(
                    "Example:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    topic["example"]!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}