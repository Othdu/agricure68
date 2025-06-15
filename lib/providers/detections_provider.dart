import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetectionsProvider extends ChangeNotifier {
  static const String _url = 'https://yoloproject-cc5f4-default-rtdb.firebaseio.com/detections.json';

  Map<String, dynamic>? _detections;
  String? _error;
  bool _isLoading = false;

  Map<String, dynamic>? get detections => _detections;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchDetections() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        _detections = json.decode(response.body) as Map<String, dynamic>?;
      } else {
        _error = 'Failed to load detections (${response.statusCode})';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 