import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tekkers/main.dart';
import 'package:tekkers/screens/home_screen.dart';
import 'package:tekkers/providers/team_provider.dart';

void main() {
  testWidgets('App renders HomeScreen with BottomNavigationBar', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TeamProvider()),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('News'), findsOneWidget);
    expect(find.text('Transfers'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Tapping on BottomNavigationBar switches screens', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TeamProvider()),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Calendar Screen'), findsOneWidget);

    // Act
    await tester.tap(find.text('News'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('News Screen'), findsOneWidget);

    // Act
    await tester.tap(find.text('Transfers'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Transfers Screen'), findsOneWidget);

    // Act
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Settings Screen'), findsOneWidget);

    // Act
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('HomeScreen displays a list of teams when loaded', (WidgetTester tester) async {
    // Arrange
    final teamProvider = TeamProvider();
    await teamProvider.loadTeams();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => teamProvider),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('HomeScreen shows loading indicator while fetching data', (WidgetTester tester) async {
    // Arrange
    final teamProvider = TeamProvider();
    teamProvider.loadTeams();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => teamProvider),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Act
    await tester.pump();

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}