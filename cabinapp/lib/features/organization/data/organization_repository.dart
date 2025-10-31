import 'package:dio/dio.dart';
import 'package:cabinapp/core/constants/endpoints.dart';
import 'package:cabinapp/core/network/api_client.dart';
import 'package:cabinapp/core/storage/secure_storage_service.dart';
import 'models/organization_model.dart';

class OrganizationRepository {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  OrganizationRepository({
    Dio? dio,
    SecureStorageService? secureStorage,
  })  : _dio = dio ?? ApiClient.build(),
        _secureStorage = secureStorage ?? SecureStorageService();
  
  // 🔹 Guardar organización activa
  Future<void> saveActiveOrganizationId(String id) async {
    await _secureStorage.saveOrganizationId(id);
  }

  // 🔹 Crear organización
  Future<OrganizationModel> createOrganization(String nombre) async {
    try {
      final response = await _dio.post(
        ApiConstants.createOrganization, // '/organization/create'
        data: {'nombre': nombre},
      );

      final data = response.data as Map<String, dynamic>;

      // Guardamos el ID de la organización recién creada
      final orgData = data['organizacion'] as Map<String, dynamic>;
      final orgId = orgData['id'].toString();
      await _secureStorage.saveOrganizationId(orgId);

      return OrganizationModel.fromJson({
        ...orgData,
        'rol': data['rol'], // agregamos el rol si existe
      });
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Error al crear la organización';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al crear la organización');
    }
  }

  // 🔹 Unirse a organización
  Future<OrganizationModel> joinOrganization(String codigoInvitacion) async {
    try {
      final response = await _dio.post(
        ApiConstants.joinOrganization, // '/organization/join'
        data: {'codigoInvitacion': codigoInvitacion},
      );

      final data = response.data as Map<String, dynamic>;

      final orgId = data['organization']['id'].toString();
      await _secureStorage.saveOrganizationId(orgId);

      return OrganizationModel.fromJson(data['organization']);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          'Error al unirse a la organización';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al unirse a la organización');
    }
  }

  // 🔹 Obtener mis organizaciones
  Future<List<OrganizationModel>> getMyOrganizations() async {
    try {
      final response = await _dio.get(ApiConstants.myOrganizations);

      final data = response.data;

      // 👇 Aseguramos compatibilidad con ambas respuestas posibles
      final orgsJson = (data is Map<String, dynamic>)
          ? (data['organizacions'] ?? data['organizations']) as List<dynamic>
          : (data as List<dynamic>);

      return orgsJson
          .map((json) => OrganizationModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          'Error al obtener tus organizaciones';
      throw Exception(message);
    } catch (e) {
      print('❌ Error en getMyOrganizations: $e');
      throw Exception('Error inesperado al obtener organizaciones');
    }
  }

  // 🔹 Obtener una organización por ID
  Future<OrganizationModel> getOrganizationById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.organizationById}/$id');

      final data = response.data as Map<String, dynamic>;
      return OrganizationModel.fromJson(data['organization']);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Error al obtener la organización';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al obtener organización');
    }
  }

  // 🔹 Leer y guardar ID de organización activa
  Future<String?> getActiveOrganizationId() async {
    return await _secureStorage.readOrganizationId();
  }

  Future<void> clearActiveOrganization() async {
    await _secureStorage.deleteOrganizationId();
  }
}
