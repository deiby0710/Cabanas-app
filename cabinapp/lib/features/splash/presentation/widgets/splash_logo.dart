import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashLogo extends StatelessWidget {
  final double size;
  final Color color; 

  const SplashLogo({super.key, this.size = 150, this.color = Colors.white,});

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
            'assets/lotties/cabin.json',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 20),

        // Texto animado de la marca
        Animate(
          effects: [
            SlideEffect(
              begin: const Offset(0, -4),
              end: const Offset(0, 0),
              duration: 3700.ms,
              curve: Curves.elasticOut,
              delay: 2800.ms,
            ),
            FadeEffect(duration: 1000.ms),
          ],
          child: Text(
            'Cabañas app',
            style: GoogleFonts.frederickaTheGreat(
              color: color, // 👈 usa el color dinámico
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
