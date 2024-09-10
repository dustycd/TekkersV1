import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date and time formatting

class MatchesScreen extends StatelessWidget {
  final int competitionId;
  final String competitionName;

  const MatchesScreen({
    required this.competitionId,
    required this.competitionName,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(competitionName, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.black, // Dark theme background
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white), // Back button color
          bottom: const TabBar(
            labelColor: Colors.blueAccent, // Highlighted tab color
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent, // Tab underline
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Table'),
              Tab(text: 'Matches'),
              Tab(text: 'Player statistics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text("Overview Content")), // Placeholder for other tabs
            const Center(child: Text("Table Content")),
            FutureBuilder<List<dynamic>>(
              future: fetchMatchesForCompetition(competitionId), // Fetch matches for the selected competition
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No matches found'));
                }

                return _buildMatchList(snapshot.data!); // Call _buildMatchList method here
              },
            ),
            const Center(child: Text("Player Statistics Content")),
          ],
        ),
      ),
    );
  }

  // Fetch matches for the selected competition
  Future<List<dynamic>> fetchMatchesForCompetition(int competitionId) async {
    const String apiKey = 'b373e81675174781839c2a00b33385b0'; // Football-data.org API key
    final response = await http.get(
      Uri.parse('https://api.football-data.org/v4/competitions/$competitionId/matches'),
      headers: {'X-Auth-Token': apiKey},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['matches'];
    } else {
      throw Exception('Failed to load matches');
    }
  }

  // Build match list categorized by date
  Widget _buildMatchList(List<dynamic> matches) {
    Map<String, List<dynamic>> categorizedMatches = {};

    // Categorize matches by date
    for (var match in matches) {
      String matchDate = match['utcDate'].substring(0, 10); // Extract the date in YYYY-MM-DD format
      if (!categorizedMatches.containsKey(matchDate)) {
        categorizedMatches[matchDate] = [];
      }
      categorizedMatches[matchDate]!.add(match);
    }

    return ListView(
      children: categorizedMatches.entries.map((entry) {
        String dateKey = DateFormat('EEEE, d MMM').format(DateTime.parse(entry.key));
        return _buildDateSection(dateKey, entry.value); // Call _buildDateSection
      }).toList(),
    );
  }

  // Build date section containing a header and a list of matches
  Widget _buildDateSection(String date, List<dynamic> matches) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...matches.map((match) => _buildMatchTile(match)).toList(),
        ],
      ),
    );
  }

  // Build individual match tile with logos, scores, and match status
  Widget _buildMatchTile(dynamic match) {
    String homeTeamName = match['homeTeam']['name'];
    String awayTeamName = match['awayTeam']['name'];
    String? homeCrestUrl = match['homeTeam']['crest'];
    String? awayCrestUrl = match['awayTeam']['crest'];
    String matchStatus = match['status'];
    String scoreHome = match['score']['fullTime']['homeTeam']?.toString() ?? '-';
    String scoreAway = match['score']['fullTime']['awayTeam']?.toString() ?? '-';
    String statusMessage;

    if (matchStatus == 'LIVE') {
      int minutesPlayed = DateTime.now().difference(DateTime.parse(match['utcDate'])).inMinutes;
      statusMessage = '$minutesPlayed\'';
    } else if (matchStatus == 'FINISHED') {
      statusMessage = 'FT';
    } else {
      statusMessage = DateFormat('h:mm a').format(DateTime.parse(match['utcDate']));
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: SizedBox(
          width: 45, // Fixed width for consistent alignment
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statusMessage,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Smaller font size for time/status
              ),
            ],
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTeamLogo(homeCrestUrl),
                      const SizedBox(width: 8),
                      Expanded(child: Text(homeTeamName, style: const TextStyle(fontSize: 14))), // Smaller font size for team name
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildTeamLogo(awayCrestUrl),
                      const SizedBox(width: 8),
                      Expanded(child: Text(awayTeamName, style: const TextStyle(fontSize: 14))), // Smaller font size for team name
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  scoreHome,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  scoreAway,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        trailing: _buildPopupMenu(match),
      ),
    );
  }

  // Build popup menu for toggling notifications and adding to favorites
  Widget _buildPopupMenu(dynamic match) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 1:
            print('Toggle notifications for match: ${match['id']}');
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.notifications, size: 18),
              SizedBox(width: 8),
              Text("Toggle Notifications"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.favorite_border, size: 18),
              SizedBox(width: 8),
              Text("Add to Favorites"),
            ],
          ),
        ),
      ],
    );
  }

  // Build team logo widget
  Widget _buildTeamLogo(String? crestUrl) {
    return crestUrl != null
        ? Image.network(
            crestUrl,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_soccer, size: 24),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            },
          )
        : const Icon(Icons.sports_soccer, size: 24);
  }
}