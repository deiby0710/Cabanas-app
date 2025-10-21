import 'dart:math';

/// 🔹 Mock de base de datos local (simulación de Firestore)
final List<Map<String, dynamic>> mockOrganizations = [];

class OrganizationRepository {
  // 🔹 Crear organización nueva
  Future<Map<String, dynamic>> createOrganization({
    required String orgName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // simula red

    final id = 'org_${DateTime.now().millisecondsSinceEpoch}';
    final code = _generateInviteCode(orgName);

    final newOrg = {
      'id': id,
      'name': orgName,
      'inviteCode': code,
      'createdBy': 'mockUser',
      'createdAt': DateTime.now().toIso8601String(),
      'users': [
        {'id': 'mockUser', 'role': 'admin'}
      ],
    };

    mockOrganizations.add(newOrg);
    return newOrg;
  }

  // 🔹 Buscar organización por código
  Future<Map<String, dynamic>> getOrganizationByInviteCode(String inviteCode) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final org = mockOrganizations.firstWhere(
      (org) => org['inviteCode'] == inviteCode,
      orElse: () => {},
    );

    if (org.isEmpty) {
      throw Exception('Código inválido o no encontrado');
    }

    return org;
  }

  // 🔹 Unirse mediante código (devuelve la organización encontrada)
  Future<Map<String, dynamic>> joinOrganizationByCode({
    required String inviteCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final orgIndex = mockOrganizations.indexWhere(
      (org) => org['inviteCode'] == inviteCode,
    );

    if (orgIndex == -1) {
      throw Exception('Código inválido o no encontrado');
    }

    final org = mockOrganizations[orgIndex];

    // Agregamos usuario simulado a la lista de miembros
    (org['users'] as List).add({
      'id': 'mockMember_${DateTime.now().millisecondsSinceEpoch}',
      'role': 'member',
    });

    return org;
  }

  // 🔹 Generar código tipo BOSQUE-1234
  String _generateInviteCode(String orgName) {
    final cleaned = orgName.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final prefix = cleaned.isEmpty
        ? 'ORG'
        : cleaned.substring(0, min(6, cleaned.length)).padRight(6, 'X');
    final random = Random().nextInt(9000) + 1000;
    return '$prefix-$random';
  }

    // 🔹 Obtener organización por ID (mock)
  Map<String, dynamic>? getOrganizationById(String orgId) {
    try {
      return mockOrganizations.firstWhere(
        (org) => org['id'] == orgId,
        orElse: () => {},
      );
    } catch (e) {
      return null;
    }
  }

}
