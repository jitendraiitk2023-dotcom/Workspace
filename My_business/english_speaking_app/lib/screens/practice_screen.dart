import 'package:flutter/material.dart';
import 'lesson_screen.dart';
import 'conversation_screen.dart';
import 'pronunciation_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Practice"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPracticeCard(
              context,
              Icons.mic,
              "AI Speaking",
            ),
            const SizedBox(height: 20),
            _buildPracticeCard(
              context,
              Icons.chat,
              "Conversation",
            ),
            const SizedBox(height: 20),
            _buildPracticeCard(
              context,
              Icons.volume_up,
              "Pronunciation",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeCard(
      BuildContext context,
      IconData icon,
      String title,
      ) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          if (title == "AI Speaking") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LessonScreen(
                  topic: "AI Speaking",
                ),
              ),
            );
          } else if (title == "Conversation") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ConversationScreen(),
              ),
            );
          } else if (title == "Pronunciation") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PronunciationScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}