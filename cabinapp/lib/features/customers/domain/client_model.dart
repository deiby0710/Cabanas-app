class ClientModel {
  final int id;
  final String nombre;
  final String celular;
  final int organizacionId;
  final DateTime fechaRegistro;

  ClientModel({
    required this.id,
    required this.nombre,
    required this.celular,
    required this.organizacionId,
    required this.fechaRegistro,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      nombre: json['nombre'],
      celular: json['celular'],
      organizacionId: json['organizacionId'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'celular': celular,
      'organizacionId': organizacionId,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }
}