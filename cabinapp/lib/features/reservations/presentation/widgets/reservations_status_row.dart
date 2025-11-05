import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class ReservationsStatusRow extends StatelessWidget {
  const ReservationsStatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 Primera fila
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatusIndicator(
              color: Colors.amber,
              label: local.statusPending, // Separada
              theme: theme,
            ),
            const SizedBox(width: 24),
            _StatusIndicator(
              color: Colors.green,
              label: local.statusConfirmed, // Reservada
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 🔹 Segunda fila
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatusIndicator(
              color: Colors.red,
              label: local.statusCanceled, // Cancelada
              theme: theme,
            ),
            const SizedBox(width: 24),
            _StatusIndicator(
              color: Colors.blueAccent,
              label: local.statusCompleted, // Completada
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color color;
  final String label;
  final ThemeData theme;

  const _StatusIndicator({
    required this.color,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}