import 'package:flutter/material.dart';

class FarmDataProvider with ChangeNotifier {
  String temperature = '28°C';
  String weatherCondition = 'Sunny with partial clouds';
  String humidity = '60%';
  String wind = '12 km/h';

  List<Map<String, String>> cropCalendar = [
    {'activity': 'Plant Tomato Seeds', 'time': 'Tomorrow'},
    {'activity': 'Fertilize Corn Field', 'time': 'In 3 days'},
    {'activity': 'Harvest Wheat', 'time': 'Next Week'},
  ];

  List<Map<String, String>> marketPrices = [
    {'crop': 'Wheat', 'price': '2500 EGP/ton'},
    {'crop': 'Corn', 'price': '1800 EGP/ton'},
    {'crop': 'Soybeans', 'price': '2000 EGP/ton'},
  ];

  List<Map<String, String>> farmStats = [
    {'label': 'Total Crops', 'value': '12'},
    {'label': 'Land Area', 'value': '150 ha'},
    {'label': 'Water Usage', 'value': '750L/day'},
  ];

  List<String> quickTips = [
    'Ensure consistent watering for young seedlings.',
    'Monitor for pests daily, especially after rain.',
    'Rotate crops annually to maintain soil health.',
  ];
} 