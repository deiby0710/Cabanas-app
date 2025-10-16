import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashLogo extends StatelessWidget {
  final double size;

  const SplashLogo({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lottie
        Animate(
          effects: [
            FadeEffect(duration: 1500.ms),
            ScaleEffect(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          ],
          child: Lottie.asset(
            'assets/lotties/cabin.json', // 👈 asegúrate de que la carpeta sea "lottie", no "lotties"
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 20),

        // Texto opcional de la marca o app
        Animate(
          effects: [
            SlideEffect(
              begin: const Offset(0, -4), // 👈 empieza arriba de la pantalla
              end: const Offset(0, 0),     // termina en su posición normal
              duration: 3700.ms,
              curve: Curves.elasticOut,    // 🎯 efecto de rebote
              delay: 2800.ms,               // espera un poco para sincronizar con el logo
            ),
            FadeEffect(duration: 1000.ms), // aparece suavemente
          ],
          child: Text(
            'Cabañas app',
            style: GoogleFonts.frederickaTheGreat(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}