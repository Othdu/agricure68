import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

class SensorDataProvider with ChangeNotifier {
  SensorData? _sensorData;
  bool _isLoading = false;
  String? _error;

  SensorData? get sensorData => _sensorData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSensorData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Simulate data
    _sensorData = SensorData(
      temperature: 18,
      humidity: 25,
      soilMoisture1: 15,
      soilMoisture2: 50,
      soilMoisture3: 45,
      soilMoisture4: 70,
    );

    _isLoading = false;
    notifyListeners();
  }
} 