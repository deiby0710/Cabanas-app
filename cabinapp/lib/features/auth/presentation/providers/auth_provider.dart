import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import '../../data/models/user_model.dart';
import 'package:cabinapp/core/storage/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage = SecureStorageService();

  AuthProvider(this._authRepository);

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false; // Para saber si ya intentamos auto-login

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  // 🔹 LOGIN
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final loggedUser = await _authRepository.login(email, password);
      _user = loggedUser;
      _errorMessage = null;
    } catch (e) {
      _user = null;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 REGISTER
  Future<void> register(String nombre, String email, String password) async {
    _setLoading(true);
    try {
      final newUser = await _authRepository.register(nombre, email, password);
      _user = newUser;
      _errorMessage = null;
    } catch (e) {
      _user = null;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 AUTO-LOGIN
  Future<void> tryAutoLogin() async {
    _setLoading(true);
    try {
      final token = await _secureStorage.readAccessToken();
      if (token == null) {
        _user = null;
        return;
      }

      final user = await _authRepository.getCurrentUser();
      _user = user;
      _errorMessage = null;
    } catch (e) {
      // Si falla (token expirado o inválido), limpiamos
      await _secureStorage.deleteAccessToken();
      _user = null;
      _errorMessage = null;
    } finally {
      _isInitialized = true;
      _setLoading(false);
    }
  }

  // 🔹 LOGOUT
  Future<void> logout() async {
    await _secureStorage.deleteAccessToken();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // 🔹 Estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
