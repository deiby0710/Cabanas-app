class OrganizationModel {
  final String id;
  final String nombre;
  final String codigoInvitacion;
  final String? role;


  OrganizationModel({
    required this.id,
    required this.nombre,
    required this.codigoInvitacion,
    required this.role
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    final org = json['organizacion'] ?? json;
    return OrganizationModel(
      id: org['id'].toString(),
      nombre: org['nombre'] ?? '',
      codigoInvitacion: org['codigoInvitacion'] ?? '',
      role: json['rol'] ?? 'USER',
    );
  }
}