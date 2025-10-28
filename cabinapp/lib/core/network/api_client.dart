import 'package:dio/dio.dart';
import 'package:cabinapp/core/network/interceptors/auth_interceptor.dart';
import 'package:cabinapp/core/constants/endpoints.dart';

class ApiClient {
  static Dio build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // ✅ Interceptor para agregar el token JWT automáticamente
    dio.interceptors.add(AuthInterceptor());

    // ✅ Interceptor para ver logs en consola (opcional pero útil)
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('[API] $obj'),
      ),
    );

    return dio;
  }
}
