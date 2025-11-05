import 'package:cabinapp/features/reservations/domain/reservation_model.dart';
import 'package:cabinapp/features/reservations/presentation/provider/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ReservationCard extends StatelessWidget {
  final String name;
  final int capacity;
  final String status;
  final int index;

  final ReservationModel reservationModel;

  const ReservationCard({
    super.key,
    required this.name,
    required this.capacity,
    required this.status,
    required this.index,
    required this.reservationModel
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    // Normalizamos estado
    final s = status.toUpperCase();

    late Color border;
    late Color fill;
    late Color iconColor;
    late String statusLabel;
    late IconData icon;

    // 🔹 Definimos estilo según el estado
    switch (s) {
      case 'PENDIENTE':
        border = Colors.amber.withOpacity(0.6);
        fill = Colors.amber.withOpacity(0.15);
        iconColor = Colors.amber.shade700;
        statusLabel = 'Separada';
        icon = Icons.access_time;
        break;

      case 'CONFIRMADA':
        border = Colors.green.withOpacity(0.5);
        fill = Colors.green.withOpacity(0.15);
        iconColor = Colors.green.shade600;
        statusLabel = 'Reservada';
        icon = Icons.event_available;
        break;

      case 'CANCELADA':
        border = Colors.red.withOpacity(0.5);
        fill = Colors.red.withOpacity(0.15);
        iconColor = Colors.red.shade600;
        statusLabel = 'Cancelada';
        icon = Icons.cancel;
        break;

      case 'COMPLETADA':
        border = Colors.blueAccent.withOpacity(0.5);
        fill = Colors.blueAccent.withOpacity(0.15);
        iconColor = Colors.blueAccent.shade700;
        statusLabel = 'Completada';
        icon = Icons.check_circle;
        break;

      default:
        border = Colors.grey.withOpacity(0.4);
        fill = Colors.grey.withOpacity(0.1);
        iconColor = Colors.grey;
        statusLabel = 'Desconocido';
        icon = Icons.help_outline;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final updated = await context.push<bool>(
              '/reservations/edit',
              extra: { 'reservation': reservationModel },
            );

            if (updated == true && context.mounted) {
              // 🔹 Si el modal devolvió true, refrescamos la lista de reservas
              await context.read<ReservationsProvider>().fetchReservations();
            }
          },
          child: Card(
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