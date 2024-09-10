import 'package:flutter/material.dart';

class LiveActivitiesScreen extends StatelessWidget {
  const LiveActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Activities'),
      ),
      body: const Center(
        child: Text('Manage live activities settings here'),
      ),
    );
  }
}