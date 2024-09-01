import 'package:flutter/material.dart';

class TransfersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfers'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with dynamic data
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/player-image.png'), // Replace with actual data
            ),
            title: Text('Player Name'),
            subtitle: Text('Transfer details here'),
            trailing: Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}