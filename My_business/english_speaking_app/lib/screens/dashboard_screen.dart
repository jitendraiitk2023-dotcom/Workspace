import 'package:flutter/material.dart';
import 'lesson_screen.dart';
import 'conversation_screen.dart';
import 'vocabulary_screen.dart';
import 'pronunciation_screen.dart';
import 'progress_screen.dart';
import 'grammar_screen.dart';
import 'profile_screen.dart';
import '../widgets/progress_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("English AI"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const ProgressCard(
              xp: 250,
              streak: 5,
              level: 2,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildCard(context, Icons.mic, "AI Speaking"),
                  _buildCard(context, Icons.chat, "Conversation"),
                  _buildCard(context, Icons.menu_book, "Vocabulary"),
                  _buildCard(context, Icons.spellcheck, "Grammar"),
                  _buildCard(
                      context,
                      Icons.record_voice_over,
                      "Pronunciation"),
                  _buildCard(context, Icons.bar_chart, "Progress"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context,
      IconData icon,
      String title,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if (title == "AI Speaking") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonScreen(
                topic: "AI Speaking",
              ),
            ),
          );
        } else if (title == "Conversation") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  ConversationScreen(),
            ),
          );
        } else if (title == "Vocabulary") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  VocabularyScreen(),
            ),
          );
        } else if (title == "Grammar") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  GrammarScreen(),
            ),
          );
        } else if (title == "Pronunciation") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  PronunciationScreen(),
            ),
          );
        } else if (title == "Progress") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  ProgressScreen(),
            ),
          );
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 55,
              color: Colors.blue,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}