import 'package:flutter/material.dart';
import 'package:tekkers/screens/search_screen.dart'; // Import the SearchScreen

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('August', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_drop_down),
                Spacer(),
                Text('Sort by Time', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with dynamic data
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.sports_soccer),
                  title: Text('Team A vs Team B'),
                  subtitle: Text('Matchday X • 60,000 attendees'),
                  trailing: Icon(Icons.notifications),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}