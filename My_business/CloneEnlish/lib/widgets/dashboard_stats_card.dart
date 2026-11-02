import 'package:flutter/material.dart';

class DashboardStatsCard extends StatelessWidget {
  final int xp;
  final int streak;

  const DashboardStatsCard({
    super.key,
    required this.xp,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final int level = (xp ~/ 100) + 1;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(
              Icons.star,
              Colors.amber,
              "$xp",
              "XP",
            ),
            _buildItem(
              Icons.local_fire_department,
              Colors.orange,
              "$streak",
              "Days",
            ),
            _buildItem(
              Icons.workspace_premium,
              Colors.blue,
              "$level",
              "Level",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
      IconData icon,
      Color color,
      String value,
      String title,
      ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 35,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title),
      ],
    );
  }
}