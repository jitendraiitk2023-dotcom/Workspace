import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {
        "title": "First Lesson",
        "subtitle": "Complete your first lesson",
        "icon": Icons.emoji_events,
        "color": Colors.amber,
      },
      {
        "title": "7-Day Streak",
        "subtitle": "Practice for 7 days",
        "icon": Icons.local_fire_department,
        "color": Colors.orange,
      },
      {
        "title": "100 Words",
        "subtitle": "Learn 100 vocabulary words",
        "icon": Icons.book,
        "color": Colors.green,
      },
      {
        "title": "Grammar Master",
        "subtitle": "Finish all grammar lessons",
        "icon": Icons.school,
        "color": Colors.blue,
      },
      {
        "title": "Pronunciation Pro",
        "subtitle": "Complete 50 speaking exercises",
        "icon": Icons.mic,
        "color": Colors.purple,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final item = achievements[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item["color"] as Color,
                child: Icon(
                  item["icon"] as IconData,
                  color: Colors.white,
                ),
              ),
              title: Text(
                item["title"] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item["subtitle"] as String),
              trailing: const Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}