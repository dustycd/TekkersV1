import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/team_provider.dart';
import 'providers/match_provider.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/news_screen.dart';
import 'screens/transfers_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/search_screen.dart';
import 'screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()), // Adding MatchProvider
      ],
      child: MaterialApp(
        title: 'Tekkers',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF121212), // Mimics the dark theme in the screenshots
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF1F1F1F),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1F1F1F),
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
          ),
        ),
        home: HomeScreen(),
        routes: {
          '/calendar': (context) => CalendarScreen(),
          '/news': (context) => NewsScreen(),
          '/transfers': (context) => TransfersScreen(),
          '/settings': (context) => SettingsScreen(),
          '/search': (context) => SearchScreen(),
          // Other routes can be added here if necessary
        },
      ),
    );
  }
}