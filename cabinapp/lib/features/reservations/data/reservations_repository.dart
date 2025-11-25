import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:cabinapp/core/constants/endpoints.dart';
import 'package:cabinapp/core/network/api_client.dart';
import 'package:cabinapp/core/storage/secure_storage_service.dart';
import 'package:cabinapp/features/reservations/domain/reservation_model.dart';

class ReservationsRepository {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  ReservationsRepository({
    Dio? dio,
    SecureStorageService? secureStorage,
  })  : _dio = dio ?? ApiClient.build(),
        _secureStorage = secureStorage ?? SecureStorageService();

  /// 🔹 Obtener todas las reservas de la organización
  Future<List<ReservationModel>> getReservations() async {
    try {
      final orgId = await _secureStorage.readOrganizationId();
      if (orgId == null) throw Exception('Organización no encontrada.');

      final response = await _dio.get('${ApiConstants.reservations}/$orgId');

      print('📦 [API Response Pretty]: ${const JsonEncoder.withIndent('  ').convert(response.data)}');

      final data = response.data;

      // Aseguramos que el cuerpo sea Map y contenga la lista
      final Map<String, dynamic> jsonMap =
          data is String ? jsonDecode(data) : data;

      final reservationsJson = (jsonMap['reservations'] ?? []) as List<dynamic>;

      return reservationsJson
          .map((json) => ReservationModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Error al obtener reservas.';
      throw Exception(message);
    } catch (e) {
      print('❌ Error en getReservations: $e');
      throw Exception('Error inesperado al obtener las reservas');
    }
  }

  /// 🔹 Crear nueva reserva
  Future<ReservationModel> createReservation({
    required int cabanaId,
    required int clienteId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required double abono,
    required int numPersonas,
  }) async {
    try {
      final orgId = await _secureStorage.readOrganizationId();
      if (orgId == null) throw Exception('No hay organización activa.');

      final response = await _dio.post(
        '${ApiConstants.reservations}/create',
        data: {
          'organizacionId': int.parse(orgId),
          'cabanaId': cabanaId,
          'clienteId': clienteId,
          'fechaInicio': fechaInicio.toIso8601String(),
          'fechaFin': fechaFin.toIso8601String(),
          'abono': abono,
          'numPersonas': numPersonas,
        },
      );

      return ReservationModel.fromJson(response.data['reservation']);
    } on DioException catch (e) {
      final message =
          e.response?.data?['error'] ?? 'Error al crear la reserva';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al crear la reserva');
    }
  }

  /// 🔹 Obtener detalles de una reserva
  Future<ReservationModel> getReservationById(int reservationId) async {
    try {
      final orgId = await _secureStorage.readOrganizationId();
      if (orgId == null) throw Exception('No hay organización activa.');

      final response =
          await _dio.get('${ApiConstants.reservations}/$orgId/$reservationId');

      return ReservationModel.fromJson(response.data['reservation']);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Error al obtener la reserva';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al obtener la reserva');
    }
  }

  /// 🔹 Actualizar una reserva existente
  Future<ReservationModel> updateReservation({
    required int reservationId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final orgId = await _secureStorage.readOrganizationId();
      if (orgId == null) throw Exception('No hay organización activa.');

      final response = await _dio.put(
        '${ApiConstants.reservations}/$orgId/$reservationId',
        data: updates,
      );

      return ReservationModel.fromJson(response.data['reservation']);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Error al actualizar la reserva';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al actualizar la reserva');
    }
  }

  /// 🔹 Eliminar una reserva
  Future<void> deleteReservation(int reservationId) async {
    try {
      final orgId = await _secureStorage.readOrganizationId();
      if (orgId == null) throw Exception('No hay organización activa.');

      await _dio.delete('${ApiConstants.reservations}/$orgId/$reservationId');
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Error al eliminar la reserva';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al eliminar la reserva');
    }
  }

  // 🔹 Consultamos las reservas de una cabaña
  Future<List<ReservationModel>> getReservationsByCabin({
    required int cabanaId,
    DateTime? desde,
    DateTime? hasta,
  }) async {
    try {
      final orgId = await _secureStorage.readOrganizationId();
      if (orgId == null) throw Exception('No hay organización activa.');

      final queryParams = {
        'cabanaId': cabanaId.toString(),
        if (desde != null) 'desde': desde.toIso8601String(),
        if (hasta != null) 'hasta': hasta.toIso8601String(),
      };

      final response = await _dio.get(
        '${ApiConstants.reservations}/$orgId',
        queryParameters: queryParams,
      );

      final data = response.data['reservations'] as List<dynamic>;
      return data.map((r) => ReservationModel.fromJson(r)).toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          'Error al obtener reservas de la cabaña';
      throw Exception(message);
    } catch (_) {
      throw Exception('Error inesperado al obtener reservas de la cabaña');
    }
  }
}