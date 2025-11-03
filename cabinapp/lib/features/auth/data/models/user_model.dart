class UserModel {
  final String id;
  final String email;
  final String? nombre; // 👈 nuevo campo
  final String? role;

  UserModel({
    required this.id,
    required this.email,
    this.nombre,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
