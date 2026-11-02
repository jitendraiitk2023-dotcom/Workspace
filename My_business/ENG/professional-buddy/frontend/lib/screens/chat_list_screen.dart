import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/buddy_service.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BuddyService>().loadBuddies();
    });
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return DateFormat.jm().format(dt);
    }
    return DateFormat.MMMd().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final buddyService = context.watch<BuddyService>();
    // Only show buddies with at least one message as "chats"
    final chats = buddyService.buddies.where((b) => b.lastMessage != null).toList();
    final noChatsYet = buddyService.buddies.where((b) => b.lastMessage == null).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: RefreshIndicator(
        onRefresh: () => buddyService.loadBuddies(),
        child: buddyService.isLoading
            ? const Center(child: CircularProgressIndicator())
            : (chats.isEmpty && noChatsYet.isEmpty)
                ? const Center(
                    child: Text('No conversations yet', style: TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView(
                    children: [
                      ...chats.map((buddy) => ListTile(
                            leading: UserAvatar(
                              name: buddy.user.name,
                              colorHex: buddy.user.avatarColor,
                              imageUrl: buddy.user.avatarUrl,
                              showOnlineDot: true,
                              isOnline: buddy.user.isOnline,
                            ),
                            title: Text(buddy.user.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              buddy.lastMessage ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: buddy.unreadCount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: buddy.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_formatTime(buddy.lastMessageAt),
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                const SizedBox(height: 6),
                                if (buddy.unreadCount > 0)
                                  CircleAvatar(
                                    radius: 9,
                                    backgroundColor: AppColors.primary,
                                    child: Text('${buddy.unreadCount}',
                                        style: const TextStyle(fontSize: 10, color: Colors.white)),
                                  ),
                              ],
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ChatDetailScreen(buddy: buddy.user)),
                            ),
                          )),
                      if (noChatsYet.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                          child: Text('Start a conversation', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                        ...noChatsYet.map((buddy) => ListTile(
                              leading: UserAvatar(name: buddy.user.name, colorHex: buddy.user.avatarColor, imageUrl: buddy.user.avatarUrl),
                              title: Text(buddy.user.name),
                              subtitle: const Text('Say hello 👋'),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => ChatDetailScreen(buddy: buddy.user)),
                              ),
                            )),
                      ],
                    ],
                  ),
      ),
    );
  }
}
