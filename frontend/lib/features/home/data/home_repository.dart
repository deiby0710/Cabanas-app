import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepository {
  final _db = FirebaseFirestore.instance;

  // 🔹 Obtener datos de la organización por ID
  Future<Map<String, dynamic>?> getOrganization(String orgId) async {
    final doc = await _db.collection('organizations').doc(orgId).get();
    return doc.exists ? doc.data() : null;
  }

  // 🔹 Obtener lista de miembros de la organización
  Future<List<Map<String, dynamic>>> getOrgMembers(String orgId) async {
    final snapshot = await _db
        .collection('organizations')
        .doc(orgId)
        .collection('users')
        .get();

    return snapshot.docs.map((d) => d.data()).toList();
  }
}
