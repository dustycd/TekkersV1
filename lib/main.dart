import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tekkers/Providers/competition_provider.dart';
import 'package:tekkers/Providers/theme_manager.dart';
import 'package:tekkers/screens/splash_screen.dart'; // Import the SplashScreen
import 'providers/team_provider.dart';
import 'providers/match_provider.dart';
import 'providers/player_provider.dart';
import 'providers/news_provider.dart';
import 'providers/transfer_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => CompetitionProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tekkers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/field.png"), // Ensure this path is correct
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Child widget
          child,
        ],
      ),
    );
  }
}