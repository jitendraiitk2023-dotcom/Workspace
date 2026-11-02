import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 24),
          children: [
            Center(
              child: Column(
                children: [
                  UserAvatar(name: user.name, colorHex: user.avatarColor, imageUrl: user.avatarUrl, radius: 44),
                  const SizedBox(height: 12),
                  Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user.email, style: const TextStyle(color: AppColors.textSecondary)),
                  if (user.isPremium) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)),
                      child: const Text('PREMIUM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            _MenuTile(icon: Icons.person_outline, label: 'My Profile', onTap: () {}),
            _MenuTile(icon: Icons.workspace_premium_outlined, label: 'Manage Subscription', onTap: () {}),
            _MenuTile(icon: Icons.do_not_disturb_on_outlined, label: 'Do Not Disturb', onTap: () {}),
            _MenuTile(icon: Icons.block_outlined, label: 'Blocklist', onTap: () {}),
            _MenuTile(icon: Icons.share_outlined, label: 'Invite a Friend', onTap: () {}),
            _MenuTile(icon: Icons.mail_outline, label: 'Contact Us', onTap: () {}),
            _MenuTile(icon: Icons.star_outline, label: 'Rate Us', onTap: () {}),
            _MenuTile(icon: Icons.settings_outlined, label: 'Settings', onTap: () {}),
            _MenuTile(icon: Icons.info_outline, label: 'About Professional Buddy', onTap: () {}),
            const Divider(height: 1),
            _MenuTile(
              icon: Icons.logout,
              label: 'Logout',
              color: AppColors.danger,
              onTap: () async {
                await context.read<AuthService>().logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuTile({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(label, style: TextStyle(color: color ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
