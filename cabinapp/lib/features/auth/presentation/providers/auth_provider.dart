import 'package:flutter/material.dart';

/// Simulación de usuarios registrados (mock backend)
final List<Map<String, String>> mockUsers = [
  {
    'email': 'deibyalejandro10@gmail.com',
    'password': '123456',
    'role': 'admin',
  },
  {
    'email': 'user@bosque.com',
    'password': '123456',
    'role': 'member',
  },
];

/// Clase que representa un usuario autenticado en memoria
class MockUser {
  final String email;
  final String role;

  MockUser({required this.email, required this.role});
}

class AuthProvider extends ChangeNotifier {
  MockUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  MockUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 🔹 Login simulado
  Future<void> login(String email, String password) async {
    _setLoading(true);

    await Future.delayed(const Duration(seconds: 1)); // simula tiempo de red

    try {
      final foundUser = mockUsers.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => {},
      );

      if (foundUser.isEmpty) {
        throw Exception('Credenciales inválidas');
      }

      _user = MockUser(
        email: foundUser['email']!,
        role: foundUser['role']!,
      );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Usuario o contraseña incorrectos';
      _user = null;
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Registro simulado
  Future<void> register(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      final exists = mockUsers.any((u) => u['email'] == email);
      if (exists) {
        throw Exception('El usuario ya existe');
      }

      // Agregamos el nuevo usuario al mock
      mockUsers.add({
        'email': email,
        'password': password,
        'role': 'member',
      });

      _user = MockUser(email: email, role: 'member');
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'El usuario ya existe';
      _user = null;
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Logout
  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }

  // 🔹 Actualiza estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
