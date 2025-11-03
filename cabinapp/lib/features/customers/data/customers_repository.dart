import 'package:dio/dio.dart';
import 'package:cabinapp/core/storage/secure_storage_service.dart';
import 'package:cabinapp/core/network/api_client.dart';
import 'package:cabinapp/core/constants/endpoints.dart';
import 'package:cabinapp/features/customers/domain/client_model.dart';

class CustomersRepository {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  CustomersRepository({
    Dio? dio,
    SecureStorageService? secureStorage,
  })  : _dio = dio ?? ApiClient.build(),
        _secureStorage = secureStorage ?? SecureStorageService();

  /// 🔹 Obtener todos los clientes de la organización activa
  Future<List<ClientModel>> getCustomers() async {
    try {
      final orgId = await _secureStorage.readOrganizationId();
      print('El ORG ID ES: $orgId');
      if (orgId == null) throw Exception('No hay organización activa.');

      final response = await _dio.get('${ApiConstants.customers}/$orgId');
      final data = response.data['customers'] as List<dynamic>;

      return data.map((json) => ClientModel.fromJson(json)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Error al obtener los clientes';
      throw Exception(message);
    } catch (e) {
      throw Exception('Error inesperado al obtener los clientes');
    }
  }

  /// 🔹 Crear nuevo cliente
  Future<ClientModel> createCustomer(String nombre, String celular) async {
    try {
      final orgId = await _secureStorage.readOrganizationId();
      if (orgId == null) throw Exception('No hay organización activa.');

      final response = await _dio.post(
        '${ApiConstants.customers}/create',
        data: {
          'organizacionId': int.parse(orgId),
          'nombre': nombre,
          'celular': celular,
        },
      );

      return ClientModel.fromJson(response.data['customer']);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Error al crear el cliente';
      throw Exception(message);
    } catch (e) {
      throw Exception('Error inesperado al crear el cliente');
    }
  }
}