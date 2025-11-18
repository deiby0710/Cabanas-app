import 'package:flutter/material.dart';
import '../../data/organization_repository.dart';
import '../../data/models/organization_model.dart';

class OrganizationProvider extends ChangeNotifier {
  final OrganizationRepository _organizationRepository;

  OrganizationProvider(this._organizationRepository);

  // ----------------- ESTADO -----------------
  List<OrganizationModel> _myOrganizations = [];
  OrganizationModel? _activeOrganization;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<OrganizationModel> get myOrganizations => _myOrganizations;
  OrganizationModel? get activeOrganization => _activeOrganization;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ----------------- MÉTODOS PRINCIPALES -----------------

  /// Crea una nueva organización y la establece como activa.
  Future<void> createOrganization(String nombre) async {
    _setLoading(true);
    try {
      final newOrg = await _organizationRepository.createOrganization(nombre);
      _activeOrganization = newOrg;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  /// Se une a una organización mediante código de invitación.
  Future<void> joinOrganization(String codigoInvitacion) async {
    _setLoading(true);
    try {
      final org = await _organizationRepository.joinOrganization(codigoInvitacion);
      _activeOrganization = org;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene todas las organizaciones del usuario.
  Future<void> getMyOrganizations() async {
    _setLoading(true);
    try {
      _myOrganizations = await _organizationRepository.getMyOrganizations();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  /// Eliminar organización (solo ADMIN)
  Future<void> deleteOrganization(String orgId) async {
    _setLoading(true);
    try {
      await _organizationRepository.deleteOrganization(orgId);

      // Si fue eliminada, limpiamos la activa
      _activeOrganization = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  /// Salir de organización (USER)
  Future<void> leaveOrganization(String orgId, String userId) async {
    _setLoading(true);
    try {
      await _organizationRepository.leaveOrganization(
        orgId: orgId,
        userId: userId,
      );

      // El usuario ya no pertenece a esa org
      _activeOrganization = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga la organización activa guardada en almacenamiento seguro.
  Future<void> loadActiveOrganization() async {
    _setLoading(true);
    try {
      final orgId = await _organizationRepository.getActiveOrganizationId();
      if (orgId != null) {
        _activeOrganization =
            await _organizationRepository.getOrganizationById(orgId);
      }
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _activeOrganization = null;
      _errorMessage = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Cambia la organización activa y la guarda en almacenamiento.
  Future<void> setActiveOrganization(OrganizationModel org) async {
    _activeOrganization = org;
    await _organizationRepository.saveActiveOrganizationId(org.id);
    notifyListeners();
  }

  /// Limpia la organización activa.
  Future<void> clearActiveOrganization() async {
    await _organizationRepository.clearActiveOrganization();
    _activeOrganization = null;
    notifyListeners();
  }

  // ----------------- MÉTODOS AUXILIARES -----------------
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
