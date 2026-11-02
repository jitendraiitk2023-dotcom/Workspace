import 'user.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Buddy {
  final AppUser user;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  Buddy({
    required this.user,
    this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
  });

  factory Buddy.fromJson(Map<String, dynamic> json) {
    return Buddy(
      user: AppUser.fromJson(json['user']),
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.tryParse(json['last_message_at'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}

class BuddyRequestModel {
  final String id;
  final AppUser sender;
  final AppUser receiver;
  final String status;
  final DateTime createdAt;

  BuddyRequestModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.status,
    required this.createdAt,
  });

  factory BuddyRequestModel.fromJson(Map<String, dynamic> json) {
    return BuddyRequestModel(
      id: json['id'],
      sender: AppUser.fromJson(json['sender']),
      receiver: AppUser.fromJson(json['receiver']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
