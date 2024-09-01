import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/team_provider.dart';
import '../models/team.dart';

class HomePage extends StatelessWidget { // Ensure this is a StatelessWidget or StatefulWidget
  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Teams'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('My Teams', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () {},
                  child: Text('My Players', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: teamProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: teamProvider.teams.length,
              itemBuilder: (ctx, i) {
                Team team = teamProvider.teams[i];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: Image.network(team.logoUrl),
                    title: Text(team.name),
                    subtitle: Text('Men'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('FT'),
                        SizedBox(width: 10),
                        Icon(Icons.notifications, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}