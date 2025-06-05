import 'dart:convert';
import 'dart:async';
import 'dart:io';
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
    // Parse history data if available
    List<HistoryPoint> tempHistory = [];
    List<HistoryPoint> humidHistory = [];
    
    if (json['temperature_history'] is List) {
      tempHistory = (json['temperature_history'] as List)
          .map((h) => HistoryPoint.fromJson(h))
          .toList();
    }
    
    if (json['humidity_history'] is List) {
      humidHistory = (json['humidity_history'] as List)
          .map((h) => HistoryPoint.fromJson(h))
          .toList();
    }
    
    return SensorData(
      humidity: json['humidity'] ?? 0,
      soilMoisture1: json['soil_moisture_1'] ?? 0,
      soilMoisture2: json['soil_moisture_2'] ?? 0,
      soilMoisture3: json['soil_moisture_3'] ?? 0,
      soilMoisture4: json['soil_moisture_4'] ?? 0,
      temperature: json['temperature'] ?? 0,
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      temperatureHistory: tempHistory,
      humidityHistory: humidHistory,
    );
  }

  bool get isValid {
    // Check if values are within reasonable ranges
    return humidity >= 0 && humidity <= 100 &&  // Humidity should be 0-100%
           temperature >= -50 && temperature <= 100 && // Temperature reasonable range
           soilMoisture1 >= 0 && soilMoisture1 <= 100 && // Soil moisture should be 0-100%
           soilMoisture2 >= 0 && soilMoisture2 <= 100 &&
           soilMoisture3 >= 0 && soilMoisture3 <= 100 &&
           soilMoisture4 >= 0 && soilMoisture4 <= 100;
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
  static const String _lastUpdateKey = 'last_update';
  SensorData? _sensorData;
  bool _isLoading = false;
  String? _error;
  bool _isOffline = false;
  DateTime? _lastUpdate;
  SharedPreferences? _prefs;
  Timer? _refreshTimer;
  
  // Add lists to maintain history
  final List<HistoryPoint> _temperatureHistory = [];
  final List<HistoryPoint> _humidityHistory = [];
  static const int _maxHistoryPoints = 20; // Keep last 20 readings

  SensorData? get sensorData => _sensorData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOffline => _isOffline;
  DateTime? get lastUpdate => _lastUpdate;

  // Initialize SharedPreferences lazily
  Future<SharedPreferences> get _getPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Initialize only what's necessary at startup
  Future<void> init() async {
    // Load cached data first
    await _loadCachedData();
    // Then fetch new data
    await fetchSensorData();
    // Setup periodic refresh
    _setupRefreshTimer();
  }

  void _setupRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchSensorData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCachedData() async {
    try {
      final prefs = await _getPrefs;
      final cachedData = prefs.getString(_prefsKey);
      final lastUpdateStr = prefs.getString(_lastUpdateKey);
      
      if (lastUpdateStr != null) {
        _lastUpdate = DateTime.parse(lastUpdateStr);
      }
      
      if (cachedData != null) {
        final data = json.decode(cachedData);
        _sensorData = SensorData.fromJson(data);
        _isOffline = true;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cached data: $e');
      // Don't set error here as we're just loading cache
    }
  }

  // Save data to SharedPreferences
  Future<void> _cacheData(SensorData data) async {
    try {
      final prefs = await _getPrefs;
      await prefs.setString(_prefsKey, json.encode(data.toJson()));
      final now = DateTime.now();
      await prefs.setString(_lastUpdateKey, now.toIso8601String());
      _lastUpdate = now;
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network settings.';
    } else if (error is HttpException) {
      return 'Could not retrieve sensor data. Please try again later.';
    } else if (error is FormatException) {
      return 'Invalid data received from server.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> fetchSensorData() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = Uri.parse('https://plant-c010a-default-rtdb.europe-west1.firebasedatabase.app/.json');
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> rawData = json.decode(response.body);
        final sensorData = rawData['sensor_data'];
        if (sensorData == null) {
          throw FormatException('Missing sensor_data in response');
        }

        final now = DateTime.now().millisecondsSinceEpoch;
        
        // Add new history points
        _temperatureHistory.add(HistoryPoint(
          value: (sensorData['temperature'] as num).toDouble(),
          timestamp: now,
        ));
        
        _humidityHistory.add(HistoryPoint(
          value: (sensorData['humidity'] as num).toDouble(),
          timestamp: now,
        ));
        
        // Keep only the last N points
        if (_temperatureHistory.length > _maxHistoryPoints) {
          _temperatureHistory.removeAt(0);
        }
        if (_humidityHistory.length > _maxHistoryPoints) {
          _humidityHistory.removeAt(0);
        }

        final newData = SensorData(
          humidity: (sensorData['humidity'] as num).toInt(),
          soilMoisture1: (sensorData['soil_moisture_1'] as num).toInt(),
          soilMoisture2: (sensorData['soil_moisture_2'] as num).toInt(),
          soilMoisture3: (sensorData['soil_moisture_3'] as num).toInt(),
          soilMoisture4: (sensorData['soil_moisture_4'] as num).toInt(),
          temperature: (sensorData['temperature'] as num).toInt(),
          timestamp: now,
          temperatureHistory: List.from(_temperatureHistory), // Use maintained history
          humidityHistory: List.from(_humidityHistory),
        );
        
        if (newData.isValid) {
          _sensorData = newData;
          _isOffline = false;
          _lastUpdate = DateTime.now();
          await _cacheData(newData);
        } else {
          throw FormatException('Invalid sensor data received');
        }
      } else {
        throw HttpException('Failed to load sensor data (${response.statusCode})');
      }
    } catch (e) {
      _error = _getErrorMessage(e);
      _isOffline = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear cached data
  Future<void> clearCache() async {
    final prefs = await _getPrefs;
    await prefs.remove(_prefsKey);
    await prefs.remove(_lastUpdateKey);
    _lastUpdate = null;
    _sensorData = null;
    notifyListeners();
  }
}