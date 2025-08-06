class Cliente {
  int? id;
  String nombre;
  String? email;
  String? telefono;

  Cliente({
    this.id,
    required this.nombre,
    this.email,
    this.telefono,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
    };
  }
}