import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CabinCard extends StatelessWidget {
  final int index;

  const CabinCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          '${local.cabins} ${index + 1}',
          style: theme.textTheme.titleMedium,
        ),
      ),
    )
        // ✨ Animación aplicada con flutter_animate
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 100).ms) // Aparición suave
        .scale(begin: const Offset(0.9, 0.9)) // Ligero zoom de entrada
        .move(begin: const Offset(0, 20), curve: Curves.easeOut); // Sube suavemente
        // .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut);
  }
}