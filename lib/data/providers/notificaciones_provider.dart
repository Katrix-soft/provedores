import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificacionesProvider extends ChangeNotifier {
  bool _nuevasPolizas = true;
  bool _renovaciones = true;
  bool _pagosRechazados = true;
  bool _polizasConDeuda = true;
  bool _actualizacionSiniestros = true;
  bool _nuevosSiniestros = false;
  bool _notificacionesPush = true;
  bool _correoElectronico = false;
  
  bool _isLoaded = false;
  
  // Getters
  bool get nuevasPolizas => _nuevasPolizas;
  bool get renovaciones => _renovaciones;
  bool get pagosRechazados => _pagosRechazados;
  bool get polizasConDeuda => _polizasConDeuda;
  bool get actualizacionSiniestros => _actualizacionSiniestros;
  bool get nuevosSiniestros => _nuevosSiniestros;
  bool get notificacionesPush => _notificacionesPush;
  bool get correoElectronico => _correoElectronico;
  bool get isLoaded => _isLoaded;

  NotificacionesProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _nuevasPolizas = prefs.getBool('nuevasPolizas') ?? true;
    _renovaciones = prefs.getBool('renovaciones') ?? true;
    _pagosRechazados = prefs.getBool('pagosRechazados') ?? true;
    _polizasConDeuda = prefs.getBool('polizasConDeuda') ?? true;
    _actualizacionSiniestros = prefs.getBool('actualizacionSiniestros') ?? true;
    _nuevosSiniestros = prefs.getBool('nuevosSiniestros') ?? false;
    _notificacionesPush = prefs.getBool('notificacionesPush') ?? true;
    _correoElectronico = prefs.getBool('correoElectronico') ?? false;
    
    _isLoaded = true;
    notifyListeners();
  }

  void updateNuevasPolizas(bool value) { _nuevasPolizas = value; notifyListeners(); }
  void updateRenovaciones(bool value) { _renovaciones = value; notifyListeners(); }
  void updatePagosRechazados(bool value) { _pagosRechazados = value; notifyListeners(); }
  void updatePolizasConDeuda(bool value) { _polizasConDeuda = value; notifyListeners(); }
  void updateActualizacionSiniestros(bool value) { _actualizacionSiniestros = value; notifyListeners(); }
  void updateNuevosSiniestros(bool value) { _nuevosSiniestros = value; notifyListeners(); }
  void updateNotificacionesPush(bool value) { _notificacionesPush = value; notifyListeners(); }
  void updateCorreoElectronico(bool value) { _correoElectronico = value; notifyListeners(); }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool('nuevasPolizas', _nuevasPolizas),
      prefs.setBool('renovaciones', _renovaciones),
      prefs.setBool('pagosRechazados', _pagosRechazados),
      prefs.setBool('polizasConDeuda', _polizasConDeuda),
      prefs.setBool('actualizacionSiniestros', _actualizacionSiniestros),
      prefs.setBool('nuevosSiniestros', _nuevosSiniestros),
      prefs.setBool('notificacionesPush', _notificacionesPush),
      prefs.setBool('correoElectronico', _correoElectronico),
    ]);
  }
}
