import 'package:dio/dio.dart';
import 'package:cabinapp/core/constants/endpoints.dart';
import 'package:cabinapp/core/network/api_client.dart';
import 'package:cabinapp/core/storage/secure_storage_service.dart';
import 'models/user_model.dart';

class AuthRepository {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  AuthRepository({
    Dio? dio,
    SecureStorageService? secureStorage,
  })  : _dio = dio ?? ApiClient.build(),
        _secureStorage = secureStorage ?? SecureStorageService();

  // 🔹 LOGIN (adaptado a tu backend)
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;

      // ✅ Tu backend devuelve "token" y "admin"
      final token = data['token'] as String;
      final userJson = data['admin'] as Map<String, dynamic>;

      // ✅ Guardamos el JWT
      await _secureStorage.saveAccessToken(token);

      // ✅ Creamos el modelo del usuario
      return UserModel(
        id: userJson['id'].toString(),
        email: userJson['email'] ?? '',
        nombre: userJson['nombre'] ?? '',
        role: (data['organizations'] != null && data['organizations'].isNotEmpty)
            ? data['organizations'][0]['rol'] ?? 'USER'
            : 'USER',
      );
    } on DioException catch (e) {
      // final message = e.response?.data?['message'] ?? 'Error al iniciar sesión';
      // throw Exception(message);
      // Verificamos si el backend devuelve texto o JSON
      String message = 'Error al iniciar sesión';
      if(e.response?.data != null){
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          // Si el backend devuelve {"error": "Contraseña incorrecta"} o {"message": "..."}
          message = data['error'] ?? data['message'] ?? message;
        } else if (data is String) {
          // Si devuelve un texto plano
          message = data;
        }
      }
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al iniciar sesión');
    }
  }

  // 🔹 REGISTER (ajustado por compatibilidad, si tu backend devuelve lo mismo)
  Future<UserModel> register(String nombre, String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'nombre': nombre,
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'];
      final userJson = data['admin'];

      await _secureStorage.saveAccessToken(token);

      return UserModel(
        id: userJson['id'].toString(),
        nombre: userJson['nombre'] ?? '',
        email: userJson['email'] ?? '',
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Error al registrar usuario';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al registrar usuario');
    }
  }

  // 🔹 Obtener usuario actual (verifica token con /auth/me)
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConstants.me);
      final data = response.data as Map<String, dynamic>;

      // ✅ Tu backend devuelve {"admin": {...}, "organizations": [...]}
      final userJson = data['admin'] as Map<String, dynamic>;
      final orgs = data['organizations'] as List<dynamic>?;

      return UserModel(
        id: userJson['id'].toString(),
        email: userJson['email'] ?? '',
        nombre: userJson['nombre'] ?? '',
        role: (orgs != null && orgs.isNotEmpty)
            ? orgs[0]['rol'] ?? 'USER'
            : 'USER',
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Error al validar sesión';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al validar sesión');
    }
  }
}
