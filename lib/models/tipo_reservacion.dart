class TipoReservacion {
  int? id;
  String nombre;
  String? descripcion;
  double? precioBase;
  int? duracionEstimada; // en minutos

  TipoReservacion({
    this.id,
    required this.nombre,
    this.descripcion,
    this.precioBase,
    this.duracionEstimada,
  });

  factory TipoReservacion.fromJson(Map<String, dynamic> json) {
    return TipoReservacion(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precioBase: json['precio_base']?.toDouble(),
      duracionEstimada: json['duracion_estimada'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_base': precioBase,
      'duracion_estimada': duracionEstimada,
    };
  }
}