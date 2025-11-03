import 'package:flutter/material.dart';
import 'package:cabinapp/features/reservations/data/reservations_repository.dart';
import 'package:cabinapp/features/reservations/domain/reservation_model.dart';

class ReservationsProvider extends ChangeNotifier {
  final ReservationsRepository _repository;

  ReservationsProvider(this._repository);

  List<ReservationModel> _reservations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ReservationModel> get reservations => _reservations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Cargar reservas desde el backend
  Future<void> fetchReservations() async {
    _setLoading(true);
    try {
      _reservations = await _repository.getReservations();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Crear nueva reserva
  Future<void> createReservation({
    required int cabanaId,
    required int clienteId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required double abono,
    required int numPersonas,
  }) async {
    _setLoading(true);
    try {
      final newReservation = await _repository.createReservation(
        cabanaId: cabanaId,
        clienteId: clienteId,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        abono: abono,
        numPersonas: numPersonas,
      );
      _reservations.add(newReservation);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Eliminar una reserva
  Future<void> deleteReservation(int reservationId) async {
    try {
      await _repository.deleteReservation(reservationId);
      _reservations.removeWhere((r) => r.id == reservationId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  /// 🔹 Estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}