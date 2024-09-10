import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tekkers/screens/matches_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey =
      'b373e81675174781839c2a00b33385b0'; // football-data.org API key
  late Future<List<dynamic>> _competitions;

  @override
  void initState() {
    super.initState();
    _competitions = fetchCompetitions();
  }

  Future<List<dynamic>> fetchCompetitions() async {
    final response = await http.get(
      Uri.parse('https://api.football-data.org/v4/competitions'),
      headers: {'X-Auth-Token': apiKey},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['competitions'];
    } else {
      throw Exception('Failed to load competitions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home',
            style:
                TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/field.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content on top of the background
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Major Competitions'),
                _buildCompetitions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildCompetitions() {
    return FutureBuilder<List<dynamic>>(
      future: _competitions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _shimmerEffect();
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No competitions found',
                  style: TextStyle(color: Colors.black)));
        }

        return _buildCompetitionCards(snapshot.data!);
      },
    );
  }

  Widget _buildCompetitionCards(List<dynamic> competitions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics:
            NeverScrollableScrollPhysics(), // Disable scrolling since it's wrapped in SingleChildScrollView
        shrinkWrap: true, // Ensure it wraps the content
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 16.0, // Spacing between columns
          mainAxisSpacing: 16.0, // Spacing between rows
          childAspectRatio: 0.8, // Adjust this to control card height
        ),
        itemCount: competitions.length,
        itemBuilder: (context, index) {
          final competition = competitions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchesScreen(
                    competitionId: competition['id'], // Pass competition ID
                    competitionName:
                        competition['name'], // Pass competition name
                  ),
                ),
              );
            },
            child: _buildCompetitionCard(competition),
          );
        },
      ),
    );
  }

  Widget _buildCompetitionCard(dynamic competition) {
    final String logoUrl =
        competition['emblem'] ?? ''; // Get logo URL from API response

    return Card(
      color: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              logoUrl, // Use the emblem URL from the API
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback in case image fails to load
                return Icon(Icons.sports_soccer, size: 40, color: Colors.black);
              },
            ),
            const SizedBox(height: 8),
            Text(
              competition['name'],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              competition['area']['name'],
              style: const TextStyle(
                  color: Color.fromARGB(255, 160, 160, 160), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[700]!,
      highlightColor: Colors.grey[500]!,
      child: Container(
        height: 160,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 130,
              height: 160,
            ),
          ),
        ),
      ),
    );
  }
}
