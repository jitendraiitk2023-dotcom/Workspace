import 'package:flutter/material.dart';

class GrammarResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const GrammarResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final List suggestions =
    result["suggestions"] as List;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grammar Analysis"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              "🎤 Your Speech",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  result["original"],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "🤖 Corrected Sentence",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  result["corrected"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "⭐ Grammar Score",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: (result["score"] as double) / 10,
              minHeight: 12,
              borderRadius:
              BorderRadius.circular(10),
            ),

            const SizedBox(height: 10),

            Text(
              "${result["score"]}/10",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "💡 Suggestions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (suggestions.isEmpty)
              const Card(
                child: ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text(
                    "Excellent! No grammar mistakes found.",
                  ),
                ),
              )
            else
              ...suggestions.map(
                    (item) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.lightbulb,
                      color: Colors.orange,
                    ),
                    title: Text(item.toString()),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Practice Again",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
