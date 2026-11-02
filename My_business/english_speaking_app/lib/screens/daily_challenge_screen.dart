import 'package:flutter/material.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() =>
      _DailyChallengeScreenState();
}

class _DailyChallengeScreenState
    extends State<DailyChallengeScreen> {

  final List<Map<String, dynamic>> challenges = [
    {
      "title": "Learn 5 New Words",
      "done": false,
    },
    {
      "title": "Practice Speaking for 10 Minutes",
      "done": false,
    },
    {
      "title": "Complete 1 Grammar Lesson",
      "done": false,
    },
    {
      "title": "Have 1 AI Conversation",
      "done": false,
    },
    {
      "title": "Read 1 English Paragraph",
      "done": false,
    },
  ];

  @override
  Widget build(BuildContext context) {

    int completed =
        challenges.where((item) => item["done"] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Challenge"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade100,
            child: Column(
              children: [

                const Text(
                  "Today's Progress",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "$completed / ${challenges.length} Completed",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {

                return CheckboxListTile(
                  title: Text(challenges[index]["title"]),
                  value: challenges[index]["done"],
                  onChanged: (value) {

                    setState(() {
                      challenges[index]["done"] = value;
                    });

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}