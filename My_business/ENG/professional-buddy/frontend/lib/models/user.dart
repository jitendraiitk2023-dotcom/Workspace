class AppUser {
  final String id;
  final String name;
  final String email;
  final String avatarColor;
  final String? avatarUrl;
  final String? bio;
  final bool isPremium;
  final bool isOnline;
  final DateTime lastSeen;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarColor,
    this.avatarUrl,
    this.bio,
    required this.isPremium,
    required this.isOnline,
    required this.lastSeen,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarColor: json['avatar_color'] ?? '#3B82F6',
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      isPremium: json['is_premium'] ?? false,
      isOnline: json['is_online'] ?? false,
      lastSeen: DateTime.tryParse(json['last_seen'] ?? '') ?? DateTime.now(),
    );
  }
}
