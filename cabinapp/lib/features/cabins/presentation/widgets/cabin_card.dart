import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 👈 Import necesario

class CabinCard extends StatelessWidget {
  final int index;
  final String name;
  final int capacity;

  const CabinCard({
    super.key,
    required this.index,
    required this.name,
    required this.capacity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final card = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surface,
      shadowColor: theme.shadowColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ evita el overflow
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.cabin,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Capacidad: $capacity',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );

    // 👇 Animación idéntica a la usada en CustomerCard
    return card
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 100).ms)
        .scale(begin: const Offset(0.9, 0.9))
        .move(begin: const Offset(0, 20), curve: Curves.easeOut);
  }
}