import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/buddy_service.dart';
import 'services/chat_service.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProfessionalBuddyApp());
}

class ProfessionalBuddyApp extends StatelessWidget {
  const ProfessionalBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..tryAutoLogin()),
        ChangeNotifierProvider(create: (_) => BuddyService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        title: 'Professional Buddy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const _RootRouter(),
      ),
    );
  }
}

/// Decides whether to show Login or Home based on saved-session state.
class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.currentUser != null ? const HomeScreen() : const LoginScreen();
  }
}
