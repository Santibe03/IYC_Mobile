class RestauranteDTO {
  final int? id;
  final String nombre;
  final String direccion;
  final String contacto;
  final bool? activo;

  RestauranteDTO({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.contacto,
    this.activo,
  });

  factory RestauranteDTO.fromJson(Map<String, dynamic> json) {
    return RestauranteDTO(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      contacto: json['contacto'] ?? '',
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'contacto': contacto,
      'activo': activo,
    };
  }
}
