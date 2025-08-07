class Cliente {
  int? id;
  String nombre;
  String? correo;
  String? telefono;
  String? direccion;

  Cliente({
    this.id,
    required this.nombre,
    this.correo,
    this.telefono,
    this.direccion,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      telefono: json['telefono'],
      direccion: json['direccion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'telefono': telefono,
      'direccion': direccion,
    };
  }
}