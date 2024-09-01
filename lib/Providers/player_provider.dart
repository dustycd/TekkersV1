import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/api_service.dart';

class PlayerProvider with ChangeNotifier {
  List<Player> _allPlayers = [];
  List<Player> _followedPlayers = [];
  bool _isLoading = false;

  List<Player> get allPlayers => _allPlayers;
  List<Player> get followedPlayers => _followedPlayers;
  bool get isLoading => _isLoading;

  // Method to load all players from the API
  Future<void> loadAllPlayers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allPlayers = await ApiService().fetchPlayers(); // Fetch all players from API
    } catch (error) {
      print('Error loading all players: $error'); // Error handling
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to load followed players from the API
  Future<void> loadFollowedPlayers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _followedPlayers = await ApiService().fetchFollowedPlayers(); // Fetch followed players from API
    } catch (error) {
      print('Error loading followed players: $error'); // Error handling
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}