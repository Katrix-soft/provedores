import 'package:flutter/foundation.dart';
import '../models/cliente.dart';
import '../services/api_service.dart';

class ClienteProvider extends ChangeNotifier {
  List<Cliente> _todos = mockClientes;
  String _busqueda = '';
  String _filtroRamo = 'todos'; // 'todos', 'vida', 'hogar', 'automotor', 'accidentes', 'empresas'

  List<Cliente> get clientes {
    List<Cliente> resultado = _todos;

    // Filtrar por ramo
    if (_filtroRamo != 'todos') {
      resultado = resultado.where((c) {
        switch (_filtroRamo) {
          case 'vida':      return c.ramo == RamoPoliza.vida;
          case 'hogar':     return c.ramo == RamoPoliza.hogar;
          case 'automotor': return c.ramo == RamoPoliza.automotor;
          case 'accidentes':return c.ramo == RamoPoliza.accidentes;
          case 'empresas':  return c.ramo == RamoPoliza.empresas;
          default:          return true;
        }
      }).toList();
    }

    // Filtrar por búsqueda
    if (_busqueda.isNotEmpty) {
      final q = _busqueda.toLowerCase();
      resultado = resultado.where((c) {
        return c.nombre.toLowerCase().contains(q) ||
               c.dni.contains(q) ||
               c.polizas.any((p) => p.numero.toLowerCase().contains(q));
      }).toList();
    }

    return resultado;
  }

  String get busqueda => _busqueda;
  String get filtroRamo => _filtroRamo;

  int get totalActivos   => _todos.where((c) => c.estado == EstadoCliente.activo).length;
  int get totalPendientes=> _todos.where((c) => c.estado == EstadoCliente.pendiente).length;
  int get total          => _todos.length;

  void buscar(String query) {
    _busqueda = query;
    notifyListeners();
  }

  void filtrarPorRamo(String ramo) {
    _filtroRamo = ramo;
    notifyListeners();
  }

  void limpiarFiltros() {
    _busqueda = '';
    _filtroRamo = 'todos';
    notifyListeners();
  }

  // Simula actualizar desde el ERP o llama a la API real
  Future<void> recargar() async {
    try {
      final List<dynamic> data = await apiService.get('/clientes/');
      if (data.isNotEmpty) {
        _todos = data.map((json) => Cliente.fromJson(json)).toList();
      } else {
        _todos = mockClientes; // Fallback si está vacío
      }
    } catch (e) {
      print('Error cargando clientes de la API: $e');
      _todos = mockClientes; // Fallback en caso de error para que la UI no quede vacía
    }
    notifyListeners();
  }
}
