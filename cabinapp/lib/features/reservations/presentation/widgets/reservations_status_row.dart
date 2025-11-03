import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class ReservationsStatusRow extends StatelessWidget {
  const ReservationsStatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatusIndicator(
          color: Colors.green,
          label: local.available, 
        ),
        const SizedBox(width: 20),
        _StatusIndicator(
          color: Colors.red,
          label: local.reserved, 
        ),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusIndicator({
    required this.color,
    required this.label,
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
        Text(label),
      ],
    );
  }
}