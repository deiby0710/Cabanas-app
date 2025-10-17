import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/features/auth/data/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    // Escucha cambios de sesión al iniciar la app
    _authRepository.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // 🔹 Registro
  Future<void> register(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _authRepository.registerWithEmail(email, password);
      _user = user;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Login
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _authRepository.signInWithEmail(email, password);
      _user = user;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Logout
  Future<void> logout() async {
    await _authRepository.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
