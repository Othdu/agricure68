import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  
  bool _isLoggedIn = false;
  String _userEmail = '';
  
  // Hardcoded credentials for demo
  static const String _demoEmail = 'axcesstechsolutions@gmail.com';
  static const String _demoPassword = 'axcess1234';
  
  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;
  
  // Initialize auth state from preferences
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      _userEmail = prefs.getString(_userEmailKey) ?? '';
      notifyListeners();
    } catch (e) {
      print('Error loading auth state: $e');
    }
  }
  
  // Login with hardcoded credentials
  Future<bool> login(String email, String password) async {
    // Check against hardcoded credentials
    if (email == _demoEmail && password == _demoPassword) {
      _isLoggedIn = true;
      _userEmail = email;
      
      // Save to preferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_userEmailKey, email);
      } catch (e) {
        print('Error saving auth state: $e');
      }
      
      notifyListeners();
      return true;
    }
    return false;
  }
  
  // Signup with hardcoded credentials (for demo purposes, just validates format)
  Future<bool> signup(String email, String password, String confirmPassword) async {
    // Basic validation
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return false;
    }
    
    if (password != confirmPassword) {
      return false;
    }
    
    if (password.length < 6) {
      return false;
    }
    
    // For demo purposes, we'll accept any valid email/password combination
    // In a real app, this would create a new account
    _isLoggedIn = true;
    _userEmail = email;
    
    // Save to preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
    } catch (e) {
      print('Error saving auth state: $e');
    }
    
    notifyListeners();
    return true;
  }
  
  // Logout
  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = '';
    
    // Clear preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.setString(_userEmailKey, '');
    } catch (e) {
      print('Error clearing auth state: $e');
    }
    
    notifyListeners();
  }
  
  // Get demo credentials for UI hints
  String get demoEmail => _demoEmail;
  String get demoPassword => _demoPassword;
} 