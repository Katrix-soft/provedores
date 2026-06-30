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

  // Actualiza desde la API uniendo clientes y pólizas de forma eficiente
  Future<void> recargar() async {
    try {
      final List<dynamic> dataClientes = await apiService.get('/clientes/');
      
      List<dynamic> dataPolizas = [];
      try {
        dataPolizas = await apiService.get('/polizas/');
      } catch (e) {
        print('Error cargando pólizas de la API: $e');
      }

      final polizasMap = <String, List<Poliza>>{};
      for (var p in dataPolizas) {
        final cId = p['cliente_id']?.toString() ?? '';
        polizasMap.putIfAbsent(cId, () => []).add(Poliza.fromJson(p));
      }

      final List<Cliente> clientesCargados = [];
      for (var json in dataClientes) {
        final cId = json['id']?.toString() ?? '';
        final cPolizas = polizasMap[cId] ?? [];
        
        String polPrincipal = 'Sin póliza';
        RamoPoliza ramoDominante = RamoPoliza.automotor;
        String vencimiento = json['fecha_registro'] ?? '';
        EstadoCliente estado = EstadoCliente.activo;

        if (cPolizas.isNotEmpty) {
          polPrincipal = cPolizas.first.numero;
          ramoDominante = mapRamoString(cPolizas.first.tipo);
          vencimiento = cPolizas.first.vencimiento;
          if (cPolizas.any((p) => p.estado == EstadoCliente.pendiente)) {
            estado = EstadoCliente.pendiente;
          }
        }

        clientesCargados.add(
          Cliente(
            id: cId,
            nombre: json['nombre'] ?? '',
            dni: json['dni_cuil'] ?? '',
            telefono: json['telefono'] ?? '',
            email: json['email'] ?? '',
            whatsapp: json['telefono'] ?? '',
            estado: estado,
            ramo: ramoDominante,
            polizaPrincipal: polPrincipal,
            vencimiento: vencimiento,
            polizas: cPolizas,
            historial: const [],
          )
        );
      }

      _todos = clientesCargados.isNotEmpty ? clientesCargados : mockClientes;
    } catch (e) {
      print('Error cargando clientes de la API: $e');
      _todos = mockClientes; // Fallback en caso de error para que la UI no quede vacía
    }
    notifyListeners();
  }

  // Método para crear un nuevo cliente en la API
  Future<bool> crearCliente({
    required String nombre,
    required String dniCuil,
    required String telefono,
    required String email,
    String direccion = '',
    String notas = '',
  }) async {
    try {
      final response = await apiService.post('/clientes/', {
        'nombre': nombre,
        'dni_cuil': dniCuil,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'notas': notas,
      });
      if (response != null && response['ok'] == true) {
        await recargar();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al crear cliente: $e');
      return false;
    }
  }

  // Método para eliminar un cliente de la API
  Future<bool> eliminarCliente(String id) async {
    try {
      final response = await apiService.delete('/clientes/$id');
      if (response != null && response['ok'] == true) {
        await recargar();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al eliminar cliente: $e');
      return false;
    }
  }
}

