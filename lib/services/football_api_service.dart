import 'dart:convert';
import 'package:http/http.dart' as http;

class FootballApiService {
  final String apiKey = 'b373e81675174781839c2a00b33385b0';
  final String baseUrl = 'https://api.football-data.org/v4/';

  Future<List<dynamic>> fetchCompetitions() async {
    final url = Uri.parse('${baseUrl}competitions');
    final response = await http.get(url, headers: {'X-Auth-Token': apiKey});
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['competitions'];  // Return the list of competitions
    } else {
      throw Exception('Failed to load competitions');
    }
  }

  Future<List<dynamic>> fetchTeams() async {
    final url = Uri.parse('${baseUrl}teams');
    final response = await http.get(url, headers: {'X-Auth-Token': apiKey});
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['teams'];  // Return the list of teams
    } else {
      throw Exception('Failed to load teams');
    }
  }

  Future<List<dynamic>> fetchMatches() async {
    final url = Uri.parse('${baseUrl}matches');
    final response = await http.get(url, headers: {'X-Auth-Token': apiKey});
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['matches'];  // Return the list of matches
    } else {
      throw Exception('Failed to load matches');
    }
  }

  Future<List<dynamic>> fetchNews() async {
    // Football-Data API does not provide news. Use another API if needed.
    return [];
  }
}