import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/buddy_service.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';
import 'search_buddy_screen.dart';
import 'chat_detail_screen.dart';
import 'pending_requests_screen.dart';

class BuddyListScreen extends StatefulWidget {
  const BuddyListScreen({super.key});

  @override
  State<BuddyListScreen> createState() => _BuddyListScreenState();
}

class _BuddyListScreenState extends State<BuddyListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final svc = context.read<BuddyService>();
      svc.loadBuddies();
      svc.loadPendingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final buddyService = context.watch<BuddyService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Buddies'),
        leading: IconButton(
          icon: const Icon(Icons.person_add_alt_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SearchBuddyScreen()),
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PendingRequestsScreen()),
                ),
              ),
              if (buddyService.pendingRequests.isNotEmpty)
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                    child: Text(
                      '${buddyService.pendingRequests.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => buddyService.loadBuddies(),
        child: buddyService.isLoading
            ? const Center(child: CircularProgressIndicator())
            : buddyService.buddies.isEmpty
                ? _EmptyState(onFindBuddies: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchBuddyScreen())))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: buddyService.buddies.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 78),
                    itemBuilder: (context, i) {
                      final buddy = buddyService.buddies[i];
                      return ListTile(
                        leading: UserAvatar(
                          name: buddy.user.name,
                          colorHex: buddy.user.avatarColor,
                          imageUrl: buddy.user.avatarUrl,
                          showOnlineDot: true,
                          isOnline: buddy.user.isOnline,
                        ),
                        title: Text(buddy.user.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          buddy.lastMessage ?? 'Say hello 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        trailing: buddy.unreadCount > 0
                            ? CircleAvatar(
                                radius: 10,
                                backgroundColor: AppColors.primary,
                                child: Text('${buddy.unreadCount}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                              )
                            : null,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ChatDetailScreen(buddy: buddy.user)),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onFindBuddies;
  const _EmptyState({required this.onFindBuddies});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.groups_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text('No buddies yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              'Search for people and send a buddy request to start chatting.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onFindBuddies, child: const Text('Find Buddies')),
          ],
        ),
      ),
    );
  }
}
