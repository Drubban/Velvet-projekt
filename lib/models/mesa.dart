class Mesa {
  int? id;
  String numero;
  int capacidad;
  int salonId;
  String? descripcion;

  Mesa({
    this.id,
    required this.numero,
    required this.capacidad,
    required this.salonId,
    this.descripcion,
  });

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      id: json['id'],
      numero: json['numero'],
      capacidad: json['capacidad'],
      salonId: json['salon_id'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'capacidad': capacidad,
      'salon_id': salonId,
      'descripcion': descripcion,
    };
  }
}