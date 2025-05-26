import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SensorData {
  final int humidity;
  final int soilMoisture1;
  final int soilMoisture2;
  final int soilMoisture3;
  final int soilMoisture4;
  final int temperature;
  final int timestamp;
  final List<HistoryPoint> temperatureHistory;
  final List<HistoryPoint> humidityHistory;

  SensorData({
    required this.humidity,
    required this.soilMoisture1,
    required this.soilMoisture2,
    required this.soilMoisture3,
    required this.soilMoisture4,
    required this.temperature,
    required this.timestamp,
    this.temperatureHistory = const [],
    this.humidityHistory = const [],
  });

  // Add toJson method for storing in SharedPreferences
  Map<String, dynamic> toJson() => {
    'humidity': humidity,
    'soil_moisture_1': soilMoisture1,
    'soil_moisture_2': soilMoisture2,
    'soil_moisture_3': soilMoisture3,
    'soil_moisture_4': soilMoisture4,
    'temperature': temperature,
    'timestamp': timestamp,
    'temperature_history': temperatureHistory.map((h) => h.toJson()).toList(),
    'humidity_history': humidityHistory.map((h) => h.toJson()).toList(),
  };

  factory SensorData.fromJson(Map<String, dynamic> json) {
    final sensorData = json['sensor_data'] ?? {};
    
    return SensorData(
      humidity: sensorData['humidity'] ?? 0,
      soilMoisture1: sensorData['soil_moisture_1'] ?? 0,
      soilMoisture2: sensorData['soil_moisture_2'] ?? 0,
      soilMoisture3: sensorData['soil_moisture_3'] ?? 0,
      soilMoisture4: sensorData['soil_moisture_4'] ?? 0,
      temperature: sensorData['temperature'] ?? 0,
      timestamp: sensorData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      temperatureHistory: [],
      humidityHistory: [],
    );
  }
}

class HistoryPoint {
  final double value;
  final int timestamp;

  HistoryPoint({required this.value, required this.timestamp});

  // Add toJson method for storing in SharedPreferences
  Map<String, dynamic> toJson() => {
    'value': value,
    'timestamp': timestamp,
  };

  factory HistoryPoint.fromJson(Map<String, dynamic> json) => HistoryPoint(
    value: (json['value'] ?? 0).toDouble(),
    timestamp: json['timestamp'] ?? 0,
  );
}

class SensorDataProvider extends ChangeNotifier {
  static const String _prefsKey = 'sensor_data';
  SensorData? sensorData;
  bool isLoading = false;
  String? error;
  SharedPreferences? _prefs;

  // Initialize SharedPreferences lazily
  Future<SharedPreferences> get _getPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Initialize only what's necessary at startup
  Future<void> init() async {
    // Start data fetch immediately without waiting for prefs
    fetchSensorData();
    
    // Load cached data in parallel
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    try {
      final prefs = await _getPrefs;
      final cachedData = prefs.getString(_prefsKey);
      if (cachedData != null) {
        final data = json.decode(cachedData);
        sensorData = SensorData.fromJson(data);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cached data: $e');
    }
  }

  // Save data to SharedPreferences
  Future<void> _cacheData(SensorData data) async {
    try {
      final prefs = await _getPrefs;
      await prefs.setString(_prefsKey, json.encode(data.toJson()));
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  Future<void> fetchSensorData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final url = Uri.parse('https://plant-c010a-default-rtdb.europe-west1.firebasedatabase.app/.json');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        sensorData = SensorData.fromJson(data);
        
        // Cache the new data
        await _cacheData(sensorData!);
      } else {
        error = 'Failed to load sensor data.';
        sensorData = null;
      }
    } catch (e) {
      error = 'Failed to load sensor data: ${e.toString()}';
      sensorData = null;
    }
    
    isLoading = false;
    notifyListeners();
  }

  // Clear cached data
  Future<void> clearCache() async {
    final prefs = await _getPrefs;
    await prefs.remove(_prefsKey);
  }
}