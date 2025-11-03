import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class ReservationCard extends StatelessWidget {
  final String name;
  final int capacity;
  final bool reserved;

  const ReservationCard({
    super.key,
    required this.name,
    required this.capacity,
    required this.reserved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: reserved
            ? Colors.red.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reserved ? Colors.redAccent : Colors.greenAccent,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            reserved ? Icons.event_busy : Icons.event_available,
            color: reserved ? Colors.redAccent : Colors.green,
            size: 40,
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
          const SizedBox(height: 4),
          Text(
            '${local.cabinCapacityLabel}: $capacity',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reserved ? local.reserved : local.available,
            style: theme.textTheme.bodySmall?.copyWith(
              color: reserved ? Colors.red : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}