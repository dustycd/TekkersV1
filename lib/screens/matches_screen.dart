import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tekkers/providers/match_provider.dart';
import 'package:tekkers/models/match.dart';
import 'package:tekkers/models/stand.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchesScreen extends StatefulWidget {
  final int competitionId;
  final String competitionName;

  const MatchesScreen({
    Key? key,
    required this.competitionId,
    required this.competitionName,
  }) : super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late Future<void> _fetchMatchesFuture;
  late Future<void> _fetchStandingsFuture;

  @override
  void initState() {
    super.initState();
    _fetchMatchesFuture = _fetchMatches();
    _fetchStandingsFuture = _fetchStandings();
  }

  Future<void> _fetchMatches() async {
    await Provider.of<MatchProvider>(context, listen: false)
        .fetchMatchesByCompetition(widget.competitionId);
  }

  Future<void> _fetchStandings() async {
    await Provider.of<MatchProvider>(context, listen: false)
        .fetchStandingsByCompetition(widget.competitionId);
  }

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.competitionName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent, // Transparent AppBar background
          elevation: 0, // Remove shadow
          iconTheme: const IconThemeData(color: Colors.black), // Back button color
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
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                "assets/field.png",
                fit: BoxFit.cover,
              ),
            ),
            // Semi-transparent overlay
            Container(
              color: Colors.white.withOpacity(0.8),
            ),
            // Content
            TabBarView(
              children: [
                const Center(child: Text("Overview Content")),
                // Table Tab
                FutureBuilder<void>(
                  future: _fetchStandingsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      if (matchProvider.standings.isEmpty) {
                        return const Center(child: Text('No standings found'));
                      } else {
                        return _buildStandingsTable(matchProvider.standings);
                      }
                    }
                  },
                ),
                // Matches Tab
                FutureBuilder<void>(
                  future: _fetchMatchesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      if (matchProvider.matches.isEmpty) {
                        return const Center(child: Text('No matches found'));
                      } else {
                        return _buildMatchList(matchProvider.matches);
                      }
                    }
                  },
                ),
                const Center(child: Text("Player Statistics Content")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build the standings table
  Widget _buildStandingsTable(List<Standing> standings) {
    return ListView.builder(
      itemCount: standings.length + 1, // +1 for the header row
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header row
          return _buildTableHeader();
        } else {
          // Data rows
          return _buildTableRow(standings[index - 1]);
        }
      },
    );
  }

  // Build the table header
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.grey[300],
      child: Row(
        children: [
          _buildTableCell('Pos', flex: 1, isHeader: true),
          _buildTableCell('Team', flex: 4, isHeader: true),
          _buildTableCell('P', flex: 1, isHeader: true),
          _buildTableCell('W', flex: 1, isHeader: true),
          _buildTableCell('D', flex: 1, isHeader: true),
          _buildTableCell('L', flex: 1, isHeader: true),
          _buildTableCell('GD', flex: 1, isHeader: true),
          _buildTableCell('Pts', flex: 1, isHeader: true),
        ],
      ),
    );
  }

  // Build individual table rows
  Widget _buildTableRow(Standing standing) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildTableCell('${standing.position}', flex: 1),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                standing.teamCrestUrl.isNotEmpty
                    ? Image.network(
                        standing.teamCrestUrl,
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.sports_soccer, size: 24),
                      )
                    : const Icon(Icons.sports_soccer, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    standing.teamName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          _buildTableCell('${standing.playedGames}', flex: 1),
          _buildTableCell('${standing.won}', flex: 1),
          _buildTableCell('${standing.draw}', flex: 1),
          _buildTableCell('${standing.lost}', flex: 1),
          _buildTableCell('${standing.goalDifference}', flex: 1),
          _buildTableCell('${standing.points}', flex: 1),
        ],
      ),
    );
  }

  // Build individual table cells
  Widget _buildTableCell(String text,
      {required int flex, bool isHeader = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Build match list categorized by date
  Widget _buildMatchList(List<Match> matches) {
    Map<String, List<Match>> categorizedMatches = {};

    // Categorize matches by date
    for (var match in matches) {
      String matchDate = match.utcDate.substring(0, 10); // YYYY-MM-DD format
      if (!categorizedMatches.containsKey(matchDate)) {
        categorizedMatches[matchDate] = [];
      }
      categorizedMatches[matchDate]!.add(match);
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: categorizedMatches.entries.map((entry) {
        String dateKey =
            DateFormat('EEEE, d MMM').format(DateTime.parse(entry.key));
        return _buildDateSection(dateKey, entry.value);
      }).toList(),
    );
  }

  // Build date section containing a header and a list of matches
  Widget _buildDateSection(String date, List<Match> matches) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Spacing between sections
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: matches.map((match) => _buildMatchTile(match)).toList(),
          ),
        ],
      ),
    );
  }

  // Build individual match tile with logos, scores, and match status
  Widget _buildMatchTile(Match match) {
    String homeTeamName = match.homeTeamName;
    String awayTeamName = match.awayTeamName;
    String? homeCrestUrl = match.homeTeamCrestUrl;
    String? awayCrestUrl = match.awayTeamCrestUrl;
    String matchStatus = match.status;
    String scoreHome = match.scoreHome?.toString() ?? '-';
    String scoreAway = match.scoreAway?.toString() ?? '-';
    String statusMessage;

    if (matchStatus == 'LIVE' || matchStatus == 'IN_PLAY') {
      int minutesPlayed =
          DateTime.now().difference(DateTime.parse(match.utcDate)).inMinutes;
      statusMessage = '$minutesPlayed\'';
    } else if (matchStatus == 'PAUSED') {
      statusMessage = 'HT';
    } else if (matchStatus == 'FINISHED') {
      statusMessage = 'FT';
    } else {
      statusMessage =
          DateFormat('h:mm a').format(DateTime.parse(match.utcDate).toLocal());
    }

    return Card(
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statusMessage,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        title: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    homeTeamName,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildTeamLogo(homeCrestUrl),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    awayTeamName,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildTeamLogo(awayCrestUrl),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Ensure minimal space usage
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$scoreHome',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$scoreAway',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 8), // Spacing between score and menu
            _buildPopupMenu(match),
          ],
        ),
        onTap: () {
          // Handle tap on the match tile if needed
        },
      ),
    );
  }

  // Build popup menu for toggling notifications
  Widget _buildPopupMenu(Match match) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 1) {
          _toggleNotifications(match);
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
      ],
    );
  }

  // Method to toggle notifications for a match
  void _toggleNotifications(Match match) async {
    String topic = 'match_${match.id}';
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Check if the user is already subscribed
    bool isSubscribed = await _isSubscribedToTopic(topic);

    if (isSubscribed) {
      // Unsubscribe from the topic
      await messaging.unsubscribeFromTopic(topic);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unsubscribed from notifications for ${match.homeTeamName} vs ${match.awayTeamName}',
          ),
        ),
      );
      // Update your subscription status
      _updateSubscriptionStatus(topic, false);
    } else {
      // Subscribe to the topic
      await messaging.subscribeToTopic(topic);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subscribed to notifications for ${match.homeTeamName} vs ${match.awayTeamName}',
          ),
        ),
      );
      // Update your subscription status
      _updateSubscriptionStatus(topic, true);
    }
  }

  // Helper method to check subscription status
  Future<bool> _isSubscribedToTopic(String topic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(topic) ?? false;
  }

  // Helper method to update subscription status
  void _updateSubscriptionStatus(String topic, bool isSubscribed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(topic, isSubscribed);
  }

  // Build team logo widget
  Widget _buildTeamLogo(String? crestUrl) {
    if (crestUrl != null && crestUrl.isNotEmpty) {
      return Image.network(
        crestUrl,
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.sports_soccer, size: 24),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
      );
    } else {
      return const Icon(Icons.sports_soccer, size: 24);
    }
  }
}