import 'package:flutter/material.dart';

import '../services/xp_service.dart';
import '../services/streak_service.dart';

import '../widgets/dashboard_stats_card.dart';

import 'lesson_screen.dart';
import 'conversation_screen.dart';
import 'vocabulary_screen.dart';
import 'grammar_screen.dart';
import 'pronunciation_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int xp = 0;
  int streak = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    await StreakService.updateStreak();

    final userXP = await XPService.getXP();
    final userStreak = await StreakService.getStreak();

    setState(() {
      xp = userXP;
      streak = userStreak;
    });
  }

  Widget buildButton(
      String title,
      IconData icon,
      Color color,
      Widget screen,
      ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );

          loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("English Speaking App"),
        centerTitle: true,
      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          padding: const EdgeInsets.all(20),

          children: [

            const Text(
              "Welcome 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Keep improving your English every day!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            DashboardStatsCard(
              xp: xp,
              streak: streak,
            ),

            const SizedBox(height: 25),

            buildButton(
              "Lessons",
              Icons.menu_book,
              Colors.blue,
              const LessonScreen(topic: "Daily English"),
            ),

            const SizedBox(height: 12),

            buildButton(
              "Conversation",
              Icons.chat,
              Colors.green,
              const ConversationScreen(),
            ),

            const SizedBox(height: 12),

            buildButton(
              "Vocabulary",
              Icons.book,
              Colors.deepPurple,
              const VocabularyScreen(),
            ),

            const SizedBox(height: 12),

            buildButton(
              "Grammar",
              Icons.edit,
              Colors.orange,
              const GrammarScreen(),
            ),

            const SizedBox(height: 12),

            buildButton(
              "Pronunciation",
              Icons.mic,
              Colors.red,
              const PronunciationScreen(),
            ),

            const SizedBox(height: 12),

            buildButton(
              "Progress",
              Icons.bar_chart,
              Colors.teal,
              const ProgressScreen(),
            ),

            const SizedBox(height: 12),

            buildButton(
              "Profile",
              Icons.person,
              Colors.indigo,
              const ProfileScreen(),
            ),
          ],
        ),
      ),
    );
  }
}