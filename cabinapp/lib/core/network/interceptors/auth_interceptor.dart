import 'package:dio/dio.dart';
import 'package:cabinapp/core/storage/secure_storage_service.dart';
import 'package:cabinapp/core/constants/endpoints.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final SecureStorageService _secureStorage = SecureStorageService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 🔹 No agregar token en login ni register
    if (options.path.contains(ApiConstants.login) ||
        options.path.contains(ApiConstants.register)) {
      return handler.next(options);
    }

    // 🔹 Leer token guardado
    final token = await _secureStorage.readAccessToken();

    // 🔹 Si existe, agregarlo al header
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.deleteAccessToken(); // Limpia token inválido
    }
    return handler.next(err);
  }
}
