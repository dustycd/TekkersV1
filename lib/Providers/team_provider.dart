import 'package:flutter/material.dart';
import '../models/team.dart';
import '../services/api_service.dart';

class TeamProvider with ChangeNotifier {
  List<Team> _allTeams = [];
  List<Team> _followedTeams = [];
  bool _isLoading = false;

  List<Team> get allTeams => _allTeams;
  List<Team> get followedTeams => _followedTeams;
  bool get isLoading => _isLoading;

  // Method to load all teams from the API
  Future<void> loadAllTeams() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allTeams = await ApiService().fetchTeams(); // Fetch all teams from API
    } catch (error) {
      print('Error loading all teams: $error'); // Error handling
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to load followed teams from the API
  Future<void> loadFollowedTeams() async {
    _isLoading = true;
    notifyListeners();

    try {
      _followedTeams = await ApiService().fetchFollowedTeams(); // Fetch followed teams from API
    } catch (error) {
      print('Error loading followed teams: $error'); // Error handling
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}