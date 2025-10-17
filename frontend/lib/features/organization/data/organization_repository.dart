import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationRepository {
  final _db = FirebaseFirestore.instance;

  // 🔹 Crear organización nueva
  Future<void> createOrganization({
    required String orgName,
    required String userUid,
  }) async {
    final orgRef = _db.collection('organizations').doc();

    // Generar código de invitación único
    final code = _generateInviteCode(orgName);

    await _db.runTransaction((txn) async {
      txn.set(orgRef, {
        'name': orgName,
        'inviteCode': code,
        'createdBy': userUid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Añadimos al usuario como admin
      txn.set(orgRef.collection('users').doc(userUid), {
        'role': 'admin',
        'joinedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // 🔹 Buscar la organización creada por un usuario
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> findByCreator(String userUid) async {
    final query = await _db
        .collection('organizations')
        .where('createdBy', isEqualTo: userUid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    return query.docs;
  }

  // 🔹 Unirse mediante código (sin retornar ID)
  Future<void> joinOrganizationByCode({
    required String inviteCode,
    required String userUid,
  }) async {
    final query = await _db
        .collection('organizations')
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Código inválido o no encontrado');
    }

    final orgDoc = query.docs.first.reference;

    await orgDoc.collection('users').doc(userUid).set({
      'role': 'member',
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔹 Unirse mediante código y devolver el ID
  Future<String> joinOrganizationByCodeAndReturnId({
    required String inviteCode,
    required String userUid,
  }) async {
    final query = await _db
        .collection('organizations')
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Código inválido o no encontrado');
    }

    final orgDoc = query.docs.first.reference;

    await orgDoc.collection('users').doc(userUid).set({
      'role': 'member',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    return orgDoc.id;
  }

  // 🔹 Generar código tipo BOSQUE-1234
  String _generateInviteCode(String orgName) {
    final prefix = orgName
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '')
        .substring(0, min(6, orgName.length))
        .padRight(6, 'X');
    final random = Random().nextInt(9000) + 1000;
    return '$prefix-$random';
  }
}
