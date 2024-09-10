import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // For the football loading animation
import 'main_screen.dart'; // Import MainScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for football animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Navigate to MainScreen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const MainScreen()), // Navigate to MainScreen
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 28, 28), // Adjust the background to match the icon's background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the icon.png in the center
            Image.asset(
              '/Users/ghabra/apps/tekkers/assets/icon.png',
              height: 190,
              width: 190,
              fit: BoxFit.contain, // Ensures the image fits well
            ),
            const SizedBox(height: 20),
            // Football-like loading animation
            SpinKitThreeBounce(
              color: Colors.white,
              size: 30.0,
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}
