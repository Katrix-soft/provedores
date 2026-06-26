import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeguridadProvider extends ChangeNotifier {
  bool _biometricEnabled = false;
  bool _isLoaded = false;
  
  bool get biometricEnabled => _biometricEnabled;
  bool get isLoaded => _isLoaded;

  SeguridadProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    
    _isLoaded = true;
    notifyListeners();
  }

  void updateBiometric(bool value) {
    _biometricEnabled = value;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricEnabled', _biometricEnabled);
  }
}
