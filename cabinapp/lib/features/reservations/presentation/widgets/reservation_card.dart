import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class ReservationCard extends StatelessWidget {
  final String name;
  final int capacity;
  final String status;
  final int index;

  const ReservationCard({
    super.key,
    required this.name,
    required this.capacity,
    required this.status,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    // Normalizamos estado
    final s = status.toUpperCase();
    final isReserved = s == 'RESERVADA' || s == 'CONFIRMADA' || s == 'PENDIENTE';

    // Colores adaptativos
    final Color border = isReserved
        ? Colors.red.withOpacity(0.4)
        : Colors.green.withOpacity(0.4);
    final Color fill = isReserved
        ? Colors.red.withOpacity(0.08)
        : Colors.green.withOpacity(0.08);
    final Color iconColor = isReserved ? Colors.red : Colors.green;

    final String statusLabel = isReserved ? local.reserved : local.available;
    final IconData icon = isReserved ? Icons.event_busy : Icons.event_available;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 0,
          color: fill,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: border, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 🔹 evita overflow
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 0,
                  child: Icon(icon, size: 32, color: iconColor),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${local.cabinCapacityLabel}: $capacity',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  statusLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
            // 🔹 Animación sutil
            .animate()
            .fadeIn(duration: 400.ms, delay: (index * 80).ms)
            .scale(begin: const Offset(0.95, 0.95))
            .move(begin: const Offset(0, 16), curve: Curves.easeOut);
      },
    );
  }
}