class Direccion {
  int? id;
  String calle;
  String numeroExterior;
  String? numeroInterior;
  String colonia;
  String municipio;
  String estado;
  String codigoPostal;
  String pais;
  String? referencias;

  Direccion({
    this.id,
    required this.calle,
    required this.numeroExterior,
    this.numeroInterior,
    required this.colonia,
    required this.municipio,
    required this.estado,
    required this.codigoPostal,
    this.pais = 'México',
    this.referencias,
  });

  // Constructor desde JSON
  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      id: json['id'] as int?,
      calle: json['calle'] as String,
      numeroExterior: json['numeroExterior'] as String,
      numeroInterior: json['numeroInterior'] as String?,
      colonia: json['colonia'] as String,
      municipio: json['municipio'] as String,
      estado: json['estado'] as String,
      codigoPostal: json['codigoPostal'] as String,
      pais: json['pais'] as String? ?? 'México',
      referencias: json['referencias'] as String?,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calle': calle,
      'numeroExterior': numeroExterior,
      'numeroInterior': numeroInterior,
      'colonia': colonia,
      'municipio': municipio,
      'estado': estado,
      'codigoPostal': codigoPostal,
      'pais': pais,
      'referencias': referencias,
    };
  }

  // Método para crear una copia con algunos campos modificados
  Direccion copyWith({
    int? id,
    String? calle,
    String? numeroExterior,
    String? numeroInterior,
    String? colonia,
    String? municipio,
    String? estado,
    String? codigoPostal,
    String? pais,
    String? referencias,
  }) {
    return Direccion(
      id: id ?? this.id,
      calle: calle ?? this.calle,
      numeroExterior: numeroExterior ?? this.numeroExterior,
      numeroInterior: numeroInterior ?? this.numeroInterior,
      colonia: colonia ?? this.colonia,
      municipio: municipio ?? this.municipio,
      estado: estado ?? this.estado,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      pais: pais ?? this.pais,
      referencias: referencias ?? this.referencias,
    );
  }

  @override
  String toString() {
    return '$calle #$numeroExterior${numeroInterior != null ? ' Int. $numeroInterior' : ''}, $colonia, $municipio, $estado, C.P. $codigoPostal, $pais';
  }

  // Método para comparar si dos direcciones son iguales
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Direccion &&
        other.id == id &&
        other.calle == calle &&
        other.numeroExterior == numeroExterior &&
        other.numeroInterior == numeroInterior &&
        other.colonia == colonia &&
        other.municipio == municipio &&
        other.estado == estado &&
        other.codigoPostal == codigoPostal &&
        other.pais == pais &&
        other.referencias == referencias;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        calle.hashCode ^
        numeroExterior.hashCode ^
        (numeroInterior?.hashCode ?? 0) ^
        colonia.hashCode ^
        municipio.hashCode ^
        estado.hashCode ^
        codigoPostal.hashCode ^
        pais.hashCode ^
        (referencias?.hashCode ?? 0);
  }
}