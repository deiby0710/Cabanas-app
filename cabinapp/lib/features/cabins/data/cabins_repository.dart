import 'package:dio/dio.dart';
import 'package:cabinapp/features/cabins/domain/cabin_model.dart';
import 'package:cabinapp/core/network/api_client.dart';
import 'package:cabinapp/core/constants/endpoints.dart';
import 'package:cabinapp/core/storage/secure_storage_service.dart';

class CabinsRepository {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  CabinsRepository({
    Dio? dio,
    SecureStorageService? secureStorage,
  })  : _dio = dio ?? ApiClient.build(),
        _secureStorage = secureStorage ?? SecureStorageService();

  // 🔹 Obtener todas las cabañas de la organización activa
  Future<List<CabinModel>> getCabins() async {
    try {
      final orgId = await _secureStorage.readOrganizationId(); // ✅
      if (orgId == null) throw Exception('No hay organización activa.');

      final response = await _dio.get('${ApiConstants.cabins}/$orgId');
      final data = response.data['cabins'] as List<dynamic>;
      return data.map((json) => CabinModel.fromJson(json)).toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Error al obtener las cabañas';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al obtener las cabañas');
    }
  }

  // 🔹 Crear nueva cabaña
  Future<CabinModel> createCabin(String nombre, int capacidad) async {
    try {
      final orgId = await _secureStorage.readOrganizationId(); // ✅
      if (orgId == null) throw Exception('No hay organización activa.');

      final response = await _dio.post(
        '${ApiConstants.cabins}/create',
        data: {
          'organizacionId': int.parse(orgId),
          'nombre': nombre,
          'capacidad': capacidad,
        },
      );

      return CabinModel.fromJson(response.data['cabin']);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Error al crear la cabaña';
      throw Exception(message);
    }
  }
}