import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class SplashLogo extends StatelessWidget {
  final double size;

  const SplashLogo({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo o ícono de la app
        Image.asset('assets/images/cabana.png')
          .animate()
          .fadeIn(duration: 1500.ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

        const SizedBox(height: 20),

        // Texto opcional de la marca o app
        Text(
          'Cabañas app',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

