import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  final double size;

  const SplashLogo({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo o ícono de la app
        FlutterLogo(size: size),

        const SizedBox(height: 20),

        // Texto opcional de la marca o app
        Text(
          'Mi Aplicación',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
