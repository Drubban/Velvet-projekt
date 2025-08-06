import 'cliente.dart';
import 'sucursal.dart';
import 'salon.dart';
import 'mesa.dart';
import 'tipo_reservacion.dart';

class Reservacion {
  int? id;
  Cliente cliente;
  Sucursal sucursal;
  Salon salon;
  Mesa mesa;
  TipoReservacion tipo;
  DateTime fecha;
  String? observaciones;
  String estado;

  Reservacion({
    this.id,
    required this.cliente,
    required this.sucursal,
    required this.salon,
    required this.mesa,
    required this.tipo,
    required this.fecha,
    this.observaciones,
    this.estado = 'pendiente',
  });

  factory Reservacion.fromJson(Map<String, dynamic> json) {
    return Reservacion(
      id: json['id'],
      cliente: Cliente.fromJson(json['cliente']),
      sucursal: Sucursal.fromJson(json['sucursal']),
      salon: Salon.fromJson(json['salon']),
      mesa: Mesa.fromJson(json['mesa']),
      tipo: TipoReservacion.fromJson(json['tipo']),
      fecha: DateTime.parse(json['fecha']),
      observaciones: json['observaciones'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente_id': cliente.id,
      'sucursal_id': sucursal.id,
      'salon_id': salon.id,
      'mesa_id': mesa.id,
      'tipo_id': tipo.id,
      'fecha': fecha.toIso8601String(),
      'observaciones': observaciones,
      'estado': estado,
    };
  }
}