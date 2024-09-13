// match_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tekkers/models/match.dart';
import 'package:tekkers/models/stand.dart'; // Import the Standing model

class MatchProvider with ChangeNotifier {
  final String _apiKey = 'YOUR_API_KEY'; // Replace with your API key
  final String _baseUrl = 'api.football-data.org';

  List<Match> _matches = [];
  List<Standing> _standings = []; // Added standings list

  List<Match> get matches => _matches;
  List<Standing> get standings => _standings; // Getter for standings

  // Fetch matches by competition ID
  Future<void> fetchMatchesByCompetition(int competitionId) async {
    var url = Uri.https(_baseUrl, '/v4/competitions/$competitionId/matches');

    try {
      final response = await http.get(url, headers: {
        'X-Auth-Token': _apiKey,
      });

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final List<dynamic> matchesJson = decodedResponse['matches'];
        _matches = matchesJson.map((json) => Match.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load matches: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching matches: $e');
    }
  }

  // Fetch standings by competition ID
  Future<void> fetchStandingsByCompetition(int competitionId) async {
    var url = Uri.https(_baseUrl, '/v4/competitions/$competitionId/standings');

    try {
      final response = await http.get(url, headers: {
        'X-Auth-Token': _apiKey,
      });

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final List<dynamic> standingsJson = decodedResponse['standings'][0]['table'];

        _standings = standingsJson.map((json) => Standing.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load standings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching standings: $e');
    }
  }
}