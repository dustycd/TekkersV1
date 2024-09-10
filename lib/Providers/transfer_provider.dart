import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tekkers/models/transfer.dart';

class TransferProvider with ChangeNotifier {
  final String _apiKey =
      'k7GzdfMft22V8GGIK7wAtmT2Uubs0EsGlXBqKVRVELqGjV8RCAAbMith7aiO';
  final String _baseUrl = 'https://api.sportmonks.com/v3/football/transfers';

  List<Transfer> transfers = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  Future<void> fetchTransfers() async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    notifyListeners();

    final url = Uri.parse('$_baseUrl?api_token=$_apiKey');
    try {
      final response = await http.get(url);
      print('API Response: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed data: $data'); // Debug print

        // Assuming 'data' has a 'data' field containing the transfers
        transfers = (data['data'] as List)
            .map((transferJson) => Transfer.fromJson(transferJson))
            .toList();

        // Check if transfers are fetched successfully
        if (transfers.isEmpty) {
          hasError = true;
          errorMessage = 'No transfers available';
        } else {
          hasError = false;
        }
      } else {
        hasError = true;
        errorMessage = 'Failed to load transfers: ${response.statusCode}';
      }
    } catch (error) {
      hasError = true;
      errorMessage = 'An error occurred: $error';
      print('Error fetching transfers: $error'); // Debug print
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}