import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/buddy_service.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';

class PendingRequestsScreen extends StatelessWidget {
  const PendingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buddyService = context.watch<BuddyService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buddy Requests')),
      body: buddyService.pendingRequests.isEmpty
          ? const Center(
              child: Text('No pending requests', style: TextStyle(color: AppColors.textSecondary)),
            )
          : ListView.builder(
              itemCount: buddyService.pendingRequests.length,
              itemBuilder: (context, i) {
                final req = buddyService.pendingRequests[i];
                return ListTile(
                  leading: UserAvatar(
                    name: req.sender.name,
                    colorHex: req.sender.avatarColor,
                    imageUrl: req.sender.avatarUrl,
                  ),
                  title: Text(req.sender.name),
                  subtitle: const Text('wants to be your buddy'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: AppColors.success),
                        onPressed: () => context.read<BuddyService>().respond(req.id, true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: AppColors.danger),
                        onPressed: () => context.read<BuddyService>().respond(req.id, false),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
