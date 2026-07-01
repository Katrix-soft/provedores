import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirmaProvider extends ChangeNotifier {
  List<List<Offset>> _strokes = [];
  String _titulo = 'Alex Rivers';
  bool _isLoaded = false;
  int _intentos = 0;
  
  List<List<Offset>> get strokes => _strokes;
  String get titulo => _titulo;
  bool get isLoaded => _isLoaded;
  int get intentos => _intentos;

  FirmaProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    _titulo = prefs.getString('firma_titulo') ?? 'Alex Rivers';
    _intentos = prefs.getInt('firma_intentos') ?? 0;
    
    final strokesJson = prefs.getString('firma_strokes');
    if (strokesJson != null && strokesJson.isNotEmpty) {
      try {
        List<dynamic> decoded = jsonDecode(strokesJson);
        _strokes = decoded.map((stroke) {
          return (stroke as List<dynamic>).map((point) {
            return Offset((point['x'] as num).toDouble(), (point['y'] as num).toDouble());
          }).toList();
        }).toList();
      } catch (e) {
        _strokes = [];
      }
    }
    
    _isLoaded = true;
    notifyListeners();
  }

  void updateTitulo(String value) {
    _titulo = value;
    notifyListeners();
  }

  void updateStrokes(List<List<Offset>> newStrokes) {
    _strokes = List.from(newStrokes); // Copy to ensure update
    notifyListeners();
  }

  void clearStrokes() {
    _strokes = [];
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firma_titulo', _titulo);
    
    if (_intentos < 3) {
      _intentos++;
    }
    await prefs.setInt('firma_intentos', _intentos);
    notifyListeners();
    
    // Serialize strokes
    List<List<Map<String, double>>> jsonStrokes = _strokes.map((stroke) {
      return stroke.map((offset) => {'x': offset.dx, 'y': offset.dy}).toList();
    }).toList();
    
    await prefs.setString('firma_strokes', jsonEncode(jsonStrokes));
  }
}
