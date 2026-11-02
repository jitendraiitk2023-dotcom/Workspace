import 'package:flutter/material.dart';
import '../services/xp_service.dart';
import '../services/streak_service.dart';

class ProgressCard extends StatelessWidget {
  final int streak;
  final int level;

  const ProgressCard({
    super.key,
    required this.streak,
    required this.level,
    required int xp,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: XPService.getXP(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        int xp = snapshot.data!;

        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const Text(
                  "Your Progress",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Column(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 35,
                        ),
                        const SizedBox(height: 5),
                        FutureBuilder<int>(

                          future: StreakService.getStreak(),

                          builder: (context, snapshot) {


                            if(!snapshot.hasData){

                              return const Text(
                                  "0 Days"
                              );

                            }


                            return Text(
                                "${snapshot.data} Days"
                            );


                          },

                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 35,
                        ),
                        const SizedBox(height: 5),
                        Text("$xp XP"),
                      ],
                    ),

                    Column(
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          color: Colors.blue,
                          size: 35,
                        ),
                        const SizedBox(height: 5),
                        Text("Level $level"),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                LinearProgressIndicator(
                  value: xp / 1000,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),

                const SizedBox(height: 10),

                Text("$xp / 1000 XP"),
              ],
            ),
          ),
        );
      },
    );
  }
}