class Salon {
  int? id;
  String nombre;
  String descripcion;
  int capacidad;
  int sucursalId;
  List<Mesa>? mesas;

  Salon({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.capacidad,
    required this.sucursalId,
    this.mesas,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      capacidad: json['capacidad'],
      sucursalId: json['sucursal_id'],
      mesas: json['mesas'] != null 
          ? (json['mesas'] as List).map((m) => Mesa.fromJson(m)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'capacidad': capacidad,
      'sucursal_id': sucursalId,
    };
  }
}