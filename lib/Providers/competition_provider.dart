import 'package:flutter/material.dart';
import '../models/competition.dart';
import '../services/api_service.dart';

class CompetitionProvider with ChangeNotifier {
  List<Competition> _allCompetitions = [];
  List<Competition> _followedCompetitions = [];
  bool _isLoading = false;

  List<Competition> get allCompetitions => _allCompetitions;
  List<Competition> get followedCompetitions => _followedCompetitions;
  bool get isLoading => _isLoading;

  Future<void> loadAllCompetitions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allCompetitions = await ApiService().fetchCompetitions();
    } catch (error) {
      print('Error loading competitions: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFollowedCompetitions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _followedCompetitions = await ApiService().fetchFollowedCompetitions();
    } catch (error) {
      print('Error loading followed competitions: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}