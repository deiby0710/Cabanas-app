import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/splash/presentation/widgets/splash_logo.dart';
import 'package:cabinapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:cabinapp/features/organization/presentation/providers/organization_provider.dart'; // 👈 IMPORTANTE

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = context.read<AuthProvider>();
    final orgProvider = context.read<OrganizationProvider>(); // 👈 Agregado

    // 🔹 Mostrar el logo unos segundos
    await Future.delayed(const Duration(seconds: 2));

    // 🔹 Intentar autologin
    await authProvider.tryAutoLogin();

    // 🔹 Si el usuario está autenticado, verificamos la organización activa
    if (authProvider.user != null) {
      await orgProvider.loadActiveOrganization(); // 👈 Nuevo paso

      // 🔹 Espera unos segundos más para una transición suave
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // ✅ Si hay una organización activa, ir directamente al home
      if (orgProvider.activeOrganization != null) {
        context.go('/home');
      } else {
        // 🚪 Si no hay organización, ir a seleccionar o crear
        context.go('/selectOrganization');
      }
    } else {
      // ❌ No hay sesión, ir al login
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SplashLogo(size: size.width * 0.4),
      ),
    );
  }
}
