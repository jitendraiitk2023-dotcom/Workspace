import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String colorHex;
  final String? imageUrl;
  final double radius;
  final bool showOnlineDot;
  final bool isOnline;

  const UserAvatar({
    super.key,
    required this.name,
    required this.colorHex,
    this.imageUrl,
    this.radius = 26,
    this.showOnlineDot = false,
    this.isOnline = false,
  });

  Color get _color {
    try {
      final hex = colorHex.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = imageUrl != null && imageUrl!.isNotEmpty
        ? CircleAvatar(radius: radius, backgroundImage: NetworkImage(imageUrl!))
        : CircleAvatar(
            radius: radius,
            backgroundColor: _color,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          );

    if (!showOnlineDot) return avatar;

    return Stack(
      children: [
        avatar,
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.4,
              height: radius * 0.4,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0B0E14), width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
