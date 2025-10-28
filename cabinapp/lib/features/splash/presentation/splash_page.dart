import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/splash/presentation/widgets/splash_logo.dart';
import 'package:cabinapp/features/auth/presentation/providers/auth_provider.dart';

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

    // 🔹 Espera un poquito para mostrar el logo
    await Future.delayed(const Duration(seconds: 2));

    // 🔹 Verifica si hay un token guardado y la sesión sigue activa
    await authProvider.tryAutoLogin();

    // 🔹 Espera unos segundos más para una transición suave
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 🔹 Si hay usuario, ir al home u organización; si no, al login
    if (authProvider.user != null) {
      context.go('/selectOrganization');
    } else {
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
