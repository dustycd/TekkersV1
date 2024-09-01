import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tekkers/Providers/team_provider.dart';
import 'package:tekkers/Providers/player_provider.dart';
import 'package:tekkers/Providers/competition_provider.dart'; // Ensure correct import path
import 'package:tekkers/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<void> _allTeamsFuture;
  late Future<void> _followedTeamsFuture;
  late Future<void> _allPlayersFuture;
  late Future<void> _followedPlayersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize all future calls to load data
    _allTeamsFuture = Provider.of<TeamProvider>(context, listen: false).loadAllTeams();
    _followedTeamsFuture = Provider.of<TeamProvider>(context, listen: false).loadFollowedTeams();
    _allPlayersFuture = Provider.of<PlayerProvider>(context, listen: false).loadAllPlayers();
    _followedPlayersFuture = Provider.of<PlayerProvider>(context, listen: false).loadFollowedPlayers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tekkers'),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'My Teams'),
            Tab(text: 'My Players'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Teams Tab
          FutureBuilder(
            future: _followedTeamsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading teams: ${snapshot.error}'));
              } else {
                final teamProvider = Provider.of<TeamProvider>(context);
                return ListView.builder(
                  itemCount: teamProvider.followedTeams.length,
                  itemBuilder: (ctx, i) {
                    var team = teamProvider.followedTeams[i];
                    return ListTile(
                      leading: Image.network(team.logoUrl),
                      title: Text(team.name),
                      subtitle: Text('League: ${team.name}'), // Customize this based on your data
                      trailing: Icon(Icons.notifications),
                    );
                  },
                );
              }
            },
          ),
          // My Players Tab
          FutureBuilder(
            future: _followedPlayersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading players: ${snapshot.error}'));
              } else {
                final playerProvider = Provider.of<PlayerProvider>(context);
                return ListView.builder(
                  itemCount: playerProvider.followedPlayers.length,
                  itemBuilder: (ctx, i) {
                    var player = playerProvider.followedPlayers[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(player.imageUrl),
                      ),
                      title: Text(player.name),
                      subtitle: Text('Position: ${player.position}'),
                      trailing: Icon(Icons.notifications),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}