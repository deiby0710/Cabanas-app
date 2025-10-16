import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/splash/presentation/splash_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simulación de carga o verificación de sesión
    Timer(const Duration(seconds: 8), () {
      // Aquí puedes decidir a dónde ir:
      // Por ahora, siempre va al login
      context.go('/login');
    });
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
