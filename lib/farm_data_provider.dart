import 'package:flutter/material.dart';

class FarmDataProvider extends ChangeNotifier {
  // Weather
  final String weatherCondition = 'Sunny';
  final String temperature = '28°C';
  final String humidity = '65%';
  final String wind = '12 km/h';

  // Crop Calendar
  final List<Map<String, String>> cropCalendar = [
    {'activity': 'Wheat Harvest', 'time': 'Next Week'},
    {'activity': 'Rice Planting', 'time': 'In 2 Weeks'},
    {'activity': 'Fertilizer Application', 'time': 'In 3 Days'},
  ];

  // Market Prices (EGP)
  final List<Map<String, String>> marketPrices = [
    {'crop': 'Wheat', 'price': '1,200 EGP/ton'},
    {'crop': 'Rice', 'price': '1,800 EGP/ton'},
    {'crop': 'Cotton', 'price': '4,500 EGP/ton'},
  ];

  // Farm Stats
  final List<Map<String, String>> farmStats = [
    {'label': 'Total Area', 'value': '25 Acres'},
    {'label': 'Active Crops', 'value': '3'},
    {'label': 'Yield', 'value': '85%'},
  ];

  // Quick Tips
  final List<String> quickTips = [
    'Best time to water crops: Early morning',
    'Check soil moisture before irrigation',
    'Monitor for pest infestations regularly',
  ];
} 