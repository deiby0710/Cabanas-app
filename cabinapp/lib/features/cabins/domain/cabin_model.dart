class CabinModel {
  final int id;
  final String nombre;
  final int capacidad;
  final int organizacionId;
  final DateTime fechaCreacion;

  CabinModel({
    required this.id,
    required this.nombre,
    required this.capacidad,
    required this.organizacionId,
    required this.fechaCreacion,
  });

  factory CabinModel.fromJson(Map<String, dynamic> json) {
    return CabinModel(
      id: json['id'],
      nombre: json['nombre'],
      capacidad: json['capacidad'],
      organizacionId: json['organizacionId'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }
}