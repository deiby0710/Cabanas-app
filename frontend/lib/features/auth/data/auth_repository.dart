import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Stream que emite el estado de autenticación en tiempo real
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 🔹 Usuario actual (si hay sesión activa)
  User? get currentUser => _auth.currentUser;

  // 🔹 Registro con email y contraseña
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  // 🔹 Login con email y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  // 🔹 Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔹 Manejador de errores más amigable
  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-not-found':
        return 'No existe una cuenta con este correo.';
      case 'wrong-password':
        return 'La contraseña es incorrecta.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      default:
        return 'Error desconocido: ${e.message}';
    }
  }
}
