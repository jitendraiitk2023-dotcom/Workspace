import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/streak_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/backend_test_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  // Update daily streak when app starts
  await StreakService.updateStreak();


  runApp(
      const EnglishSpeakingApp()
  );

}



class EnglishSpeakingApp extends StatelessWidget {

  const EnglishSpeakingApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'English Speaking App',


      theme: ThemeData(

        primarySwatch: Colors.blue,

      ),


      home: const MainNavigationScreen(),

    );

  }

}