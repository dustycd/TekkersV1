import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tekkers/models/match.dart'; // Replace with your actual import

class MatchProvider with ChangeNotifier {
  final String _apiKey = 'b373e81675174781839c2a00b33385b0';  // Replace with your actual API key
  final String _baseUrl = 'api.football-data.org';

  List<Match> _matches = [];

  List<Match> get matches => _matches;

  // Define the method to fetch matches by competition ID
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
}