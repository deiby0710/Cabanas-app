import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
    static const _keyAccessToken = 'access_token';
    static const _keyOrganizationId = 'organization_id';

    final FlutterSecureStorage _storage = const FlutterSecureStorage();

    // ---------------------- TOKEN ----------------------
    Future<void> saveAccessToken(String token) async {
      await _storage.write(key: _keyAccessToken, value: token);
    }

    Future<String?> readAccessToken() async {
      return _storage.read(key: _keyAccessToken);
    }

    Future<void> deleteAccessToken() async {
      await _storage.delete(key: _keyAccessToken);
    }

      // ---------------- ORGANIZACIÓN ACTIVA ----------------
    /// Guarda el ID de la organización activa.
    Future<void> saveOrganizationId(String id) async {
      await _storage.write(key: _keyOrganizationId, value: id);
    }

    /// Lee el ID de la organización activa (si existe).
    Future<String?> readOrganizationId() async {
      return _storage.read(key: _keyOrganizationId);
    }

    /// Elimina el ID de la organización activa.
    Future<void> deleteOrganizationId() async {
      await _storage.delete(key: _keyOrganizationId);
    }

    // ---------------------- GENERAL ----------------------

    /// Limpia todo el almacenamiento seguro (token, organización, etc.)
    Future<void> clearAll() async {
      await _storage.deleteAll();
    }
}