import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider extends ChangeNotifier {
  static const String _screenReaderKey = 'screen_reader_enabled';
  static const String _highContrastKey = 'high_contrast_enabled';
  static const String _largeTextKey = 'large_text_enabled';
  static const String _reduceMotionKey = 'reduce_motion_enabled';
  
  bool _screenReaderEnabled = false;
  bool _highContrastEnabled = false;
  bool _largeTextEnabled = false;
  bool _reduceMotionEnabled = false;
  bool _isInitialized = false;

  bool get screenReaderEnabled => _screenReaderEnabled;
  bool get highContrastEnabled => _highContrastEnabled;
  bool get largeTextEnabled => _largeTextEnabled;
  bool get reduceMotionEnabled => _reduceMotionEnabled;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _screenReaderEnabled = prefs.getBool(_screenReaderKey) ?? false;
      _highContrastEnabled = prefs.getBool(_highContrastKey) ?? false;
      _largeTextEnabled = prefs.getBool(_largeTextKey) ?? false;
      _reduceMotionEnabled = prefs.getBool(_reduceMotionKey) ?? false;
    } catch (e) {
      print('Error loading accessibility preferences: $e');
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setScreenReaderEnabled(bool enabled) async {
    if (_screenReaderEnabled == enabled) return;
    
    _screenReaderEnabled = enabled;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_screenReaderKey, enabled);
    } catch (e) {
      print('Error saving screen reader preference: $e');
    }
  }

  Future<void> setHighContrastEnabled(bool enabled) async {
    if (_highContrastEnabled == enabled) return;
    
    _highContrastEnabled = enabled;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_highContrastKey, enabled);
    } catch (e) {
      print('Error saving high contrast preference: $e');
    }
  }

  Future<void> setLargeTextEnabled(bool enabled) async {
    if (_largeTextEnabled == enabled) return;
    
    _largeTextEnabled = enabled;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_largeTextKey, enabled);
    } catch (e) {
      print('Error saving large text preference: $e');
    }
  }

  Future<void> setReduceMotionEnabled(bool enabled) async {
    if (_reduceMotionEnabled == enabled) return;
    
    _reduceMotionEnabled = enabled;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_reduceMotionKey, enabled);
    } catch (e) {
      print('Error saving reduce motion preference: $e');
    }
  }

  // Helper method to get text scale factor
  double get textScaleFactor => _largeTextEnabled ? 1.3 : 1.0;

  // Helper method to get animation duration
  Duration get animationDuration => _reduceMotionEnabled 
    ? const Duration(milliseconds: 100) 
    : const Duration(milliseconds: 300);
} 