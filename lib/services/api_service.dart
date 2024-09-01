import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/competition.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../models/match.dart';

class ApiService {
  final String apiKey = 'b373e81675174781839c2a00b33385b0';
  final String baseUrl = 'https://api.football-data.org/v4/';

  /// Fetch all players
  Future<List<Player>> fetchPlayers() async {
    final response = await http.get(
      Uri.parse('${baseUrl}players'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> playersJson = json.decode(response.body)['players'];
      return playersJson.map((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load players');
    }
  }

  /// Fetch followed players
  Future<List<Player>> fetchFollowedPlayers() async {
    final response = await http.get(
      Uri.parse('${baseUrl}players?followed=true'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> playersJson = json.decode(response.body)['players'];
      return playersJson.map((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load followed players');
    }
  }

  /// Fetch all teams
  Future<List<Team>> fetchTeams() async {
    final response = await http.get(
      Uri.parse('${baseUrl}teams'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> teamsJson = json.decode(response.body)['teams'];
      return teamsJson.map((json) => Team.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load teams');
    }
  }

  /// Fetch followed teams
  Future<List<Team>> fetchFollowedTeams() async {
    final response = await http.get(
      Uri.parse('${baseUrl}teams?followed=true'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> teamsJson = json.decode(response.body)['teams'];
      return teamsJson.map((json) => Team.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load followed teams');
    }
  }

  /// Fetch all matches
  Future<List<Match>> fetchMatches() async {
    final response = await http.get(
      Uri.parse('${baseUrl}matches'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> matchesJson = json.decode(response.body)['matches'];
      return matchesJson.map((json) => Match.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load matches');
    }
  }

  /// Fetch statistics for a specific match
  Future<Map<String, dynamic>> fetchMatchStatistics(int matchId) async {
    final response = await http.get(
      Uri.parse('${baseUrl}matches/$matchId/statistics'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load match statistics');
    }
  }
   /// Fetch all competitions
  Future<List<Competition>> fetchCompetitions() async {
    final response = await http.get(
      Uri.parse('${baseUrl}competitions'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> competitionsJson = json.decode(response.body)['competitions'];
      return competitionsJson.map((json) => Competition.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load competitions');
    }
  }

  /// Fetch followed competitions
  Future<List<Competition>> fetchFollowedCompetitions() async {
    final response = await http.get(
      Uri.parse('${baseUrl}competitions?followed=true'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> competitionsJson = json.decode(response.body)['competitions'];
      return competitionsJson.map((json) => Competition.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load followed competitions');
    }
  }
}