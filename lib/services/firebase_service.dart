import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class FirebaseService extends ChangeNotifier {
  static const String _databaseUrl = 'https://yoloproject-cc5f4-default-rtdb.firebaseio.com/';
  DatabaseReference? _databaseRef;
  
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _firebaseData = {};
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get firebaseData => _firebaseData;
  
  Future<void> fetchFirebaseData() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Initialize databaseRef if not already
      _databaseRef ??= FirebaseDatabase.instance.refFromURL(_databaseUrl);
      
      final snapshot = await _databaseRef!.get();
      
      if (snapshot.exists) {
        _firebaseData = Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        _firebaseData = {};
      }
      
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch data: $e';
      _firebaseData = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchSpecificPath(String path) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _databaseRef ??= FirebaseDatabase.instance.refFromURL(_databaseUrl);
      
      final snapshot = await _databaseRef!.child(path).get();
      
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          _firebaseData[path] = Map<String, dynamic>.from(data);
        } else {
          _firebaseData[path] = data;
        }
      } else {
        _firebaseData[path] = null;
      }
      
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch $path: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  List<MapEntry<String, dynamic>> getDataEntries() {
    return _firebaseData.entries.toList();
  }
  
  Map<String, dynamic>? getDataForPath(String path) {
    final keys = path.split('/');
    dynamic current = _firebaseData;
    
    for (final key in keys) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }
    
    return current is Map ? Map<String, dynamic>.from(current) : null;
  }
  
  bool hasData() {
    return _firebaseData.isNotEmpty;
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 