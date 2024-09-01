import 'package:flutter/material.dart';
import '../models/match.dart';
import '../services/api_service.dart';

class MatchProvider with ChangeNotifier {
  List<Match> _matches = [];
  bool _isLoading = false;

  List<Match> get matches => _matches;
  bool get isLoading => _isLoading;

  Future<void> loadMatches() async {
    _isLoading = true;
    notifyListeners();

    try {
      _matches = await ApiService().fetchMatches();
    } catch (error) {
      print('Error loading matches: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}