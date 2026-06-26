import 'package:flutter/foundation.dart';

enum EstadoCliente { activo, pendiente, inactivo }
enum RamoPoliza { automotor, hogar, vida, accidentes, empresas }

class Poliza {
  final String numero;
  final String tipo;
  final String compania;
  final String vencimiento;
  final String premio;
  final String sumaAsegurada;
  final EstadoCliente estado;

  const Poliza({
    required this.numero,
    required this.tipo,
    required this.compania,
    required this.vencimiento,
    this.premio = '',
    this.sumaAsegurada = '',
    required this.estado,
  });
}

class HistorialItem {
  final String titulo;
  final String descripcion;
  final String fecha;
  final String tipo; // 'success', 'error', 'info'

  const HistorialItem({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
  });
}

class Cliente {
  final String id;
  final String nombre;
  final String dni;
  final String telefono;
  final String email;
  final String whatsapp;
  final EstadoCliente estado;
  final RamoPoliza ramo;
  final String polizaPrincipal;
  final String vencimiento;
  final List<Poliza> polizas;
  final List<HistorialItem> historial;

  const Cliente({
    required this.id,
    required this.nombre,
    required this.dni,
    required this.telefono,
    required this.email,
    required this.whatsapp,
    required this.estado,
    required this.ramo,
    required this.polizaPrincipal,
    required this.vencimiento,
    this.polizas = const [],
    this.historial = const [],
  });

  String get iniciales {
    final parts = nombre.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nombre.substring(0, 2).toUpperCase();
  }

  bool get isPending => estado == EstadoCliente.pendiente;
}

// Mock data — se reemplaza con datos reales del ERP en el futuro
final List<Cliente> mockClientes = [
  Cliente(
    id: '1',
    nombre: 'Alejandro Morales',
    dni: '32.441.201',
    telefono: '+5491145521234',
    email: 'a.morales@mail.com',
    whatsapp: '+5491145521234',
    estado: EstadoCliente.activo,
    ramo: RamoPoliza.automotor,
    polizaPrincipal: 'Automotor Platinium',
    vencimiento: '12 Oct, 2024',
    polizas: [
      Poliza(
        numero: '#88219',
        tipo: 'Automotor Platinium',
        compania: 'Allianz',
        vencimiento: '12 Oct, 2024',
        premio: '\$15.000',
        sumaAsegurada: '\$12.5M',
        estado: EstadoCliente.activo,
      ),
      Poliza(
        numero: '#99402',
        tipo: 'Hogar Integral',
        compania: 'Sancor Seguros',
        vencimiento: '05 Nov, 2024',
        estado: EstadoCliente.pendiente,
      ),
    ],
    historial: [
      HistorialItem(titulo: 'Póliza Renovada', descripcion: 'Automotor Platinium - Allianz', fecha: 'HACE 2 DÍAS', tipo: 'success'),
      HistorialItem(titulo: 'Siniestro Reportado', descripcion: 'Choque en vía pública - #SIN-9021', fecha: '15 SEP, 2024', tipo: 'error'),
      HistorialItem(titulo: 'Contacto realizado', descripcion: 'Envío de cupón de pago por WhatsApp', fecha: '01 SEP, 2024', tipo: 'info'),
    ],
  ),
  Cliente(
    id: '2',
    nombre: 'Beatriz Rodríguez',
    dni: '28.102.993',
    telefono: '+5491150029876',
    email: 'b.rod@servicios.ar',
    whatsapp: '+5491150029876',
    estado: EstadoCliente.activo,
    ramo: RamoPoliza.vida,
    polizaPrincipal: 'Vida Integral',
    vencimiento: '25 Nov, 2024',
    polizas: [
      Poliza(
        numero: '#77120',
        tipo: 'Vida Integral',
        compania: 'Mapfre',
        vencimiento: '25 Nov, 2024',
        premio: '\$8.500',
        sumaAsegurada: '\$5M',
        estado: EstadoCliente.activo,
      ),
    ],
    historial: [
      HistorialItem(titulo: 'Pago Recibido', descripcion: 'Cuota mensual Vida Integral', fecha: 'HACE 5 DÍAS', tipo: 'success'),
      HistorialItem(titulo: 'Contacto realizado', descripcion: 'Llamada de seguimiento', fecha: '10 SEP, 2024', tipo: 'info'),
    ],
  ),
  Cliente(
    id: '3',
    nombre: 'Carlos López',
    dni: '35.192.448',
    telefono: '+5491122310099',
    email: 'clopez@finanzas.com',
    whatsapp: '+5491122310099',
    estado: EstadoCliente.pendiente,
    ramo: RamoPoliza.hogar,
    polizaPrincipal: 'Hogar Premium',
    vencimiento: '02 Ago, 2024',
    polizas: [
      Poliza(
        numero: '#55809',
        tipo: 'Hogar Premium',
        compania: 'Zurich',
        vencimiento: '02 Ago, 2024',
        premio: '\$22.000',
        sumaAsegurada: '\$8M',
        estado: EstadoCliente.pendiente,
      ),
    ],
    historial: [
      HistorialItem(titulo: 'Pago Vencido', descripcion: 'Cuota Hogar Premium sin abonar', fecha: 'HOY', tipo: 'error'),
      HistorialItem(titulo: 'Aviso enviado', descripcion: 'WhatsApp de aviso de vencimiento', fecha: 'HACE 3 DÍAS', tipo: 'info'),
    ],
  ),
  Cliente(
    id: '4',
    nombre: 'Diana Flores',
    dni: '40.223.111',
    telefono: '+5491199014422',
    email: 'dflores@studio.net',
    whatsapp: '+5491199014422',
    estado: EstadoCliente.activo,
    ramo: RamoPoliza.accidentes,
    polizaPrincipal: 'Accidentes Pers.',
    vencimiento: '15 Dic, 2024',
    polizas: [
      Poliza(
        numero: '#44201',
        tipo: 'Accidentes Personales',
        compania: 'Sancor Seguros',
        vencimiento: '15 Dic, 2024',
        premio: '\$5.200',
        sumaAsegurada: '\$3M',
        estado: EstadoCliente.activo,
      ),
    ],
    historial: [
      HistorialItem(titulo: 'Alta de Póliza', descripcion: 'Accidentes Personales - Sancor', fecha: '01 AGO, 2024', tipo: 'success'),
    ],
  ),
  Cliente(
    id: '5',
    nombre: 'Roberto Gomez',
    dni: '25.881.039',
    telefono: '+5491166778899',
    email: 'roberto.g@empresa.com',
    whatsapp: '+5491166778899',
    estado: EstadoCliente.pendiente,
    ramo: RamoPoliza.empresas,
    polizaPrincipal: 'Hogar Integral',
    vencimiento: '30 Sep, 2024',
    polizas: [
      Poliza(
        numero: '#8849',
        tipo: 'Hogar Integral',
        compania: 'Allianz',
        vencimiento: '30 Sep, 2024',
        premio: '\$18.400',
        sumaAsegurada: '\$10M',
        estado: EstadoCliente.pendiente,
      ),
    ],
    historial: [
      HistorialItem(titulo: 'Débito Rechazado', descripcion: 'Pago de Hogar Integral rechazado', fecha: 'HOY', tipo: 'error'),
    ],
  ),
];
