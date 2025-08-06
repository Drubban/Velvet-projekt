import 'direccion.dart';

class Sucursal {
  int? id;
  String nombre;
  String? telefono;
  String? horario;
  Direccion? direccion;

  Sucursal({
    this.id,
    required this.nombre,
    this.telefono,
    this.horario,
    this.direccion,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'],
      nombre: json['nombre'],
      telefono: json['telefono'],
      horario: json['horario'],
      direccion: json['direccion'] != null ? Direccion.fromJson(json['direccion']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'horario': horario,
      'direccion': direccion?.toJson(),
    };
  }
}