import 'package:cabinapp/core/constants/endpoints.dart';
import 'package:cabinapp/core/network/api_client.dart';
import 'package:cabinapp/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';

class AiRepository {
  final Dio _dio;
  final SecureStorageService _secure;

  AiRepository({
    Dio? dio,
    SecureStorageService? secureStorage,
  })  : _dio = dio ?? ApiClient.build(),
        _secure = secureStorage ?? SecureStorageService();

  Future<String> sendMessage(String message) async {
    try {
      final token = await _secure.readAccessToken();
      final orgId = await _secure.readOrganizationId();

      if (token == null) throw Exception("No hay token");
      if (orgId == null) throw Exception("No hay organización activa");

      final response = await _dio.post(
        "${ApiConstants.baseUrl}/ai/chat",
        data: {
          "message": message,
          "orgId": int.parse(orgId),
        },
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
      );

      return response.data["respuesta"] ?? "Sin respuesta del servidor.";
    } on DioException catch (e) {
      throw Exception(e.response?.data?["error"] ?? "Error IA");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}