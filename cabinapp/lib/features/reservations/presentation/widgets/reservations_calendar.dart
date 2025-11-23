import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cabinapp/features/reservations/domain/reservation_model.dart';

class ReservationsCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime selected, DateTime focused) onDaySelected;
  final List<dynamic> Function(DateTime) eventLoader;

  const ReservationsCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.eventLoader,
  });

  Color _estadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'PENDIENTE':
        return Colors.amber;
      case 'CONFIRMADA':
        return Colors.green;
      case 'CANCELADA':
        return Colors.red;
      case 'COMPLETADA':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TableCalendar(
      locale: Localizations.localeOf(context).toString(),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      eventLoader: eventLoader,
      onDaySelected: onDaySelected,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: theme.textTheme.titleMedium!.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        markersMaxCount: 3,
        markerSize: 6,
        markerDecoration: const BoxDecoration(shape: BoxShape.circle),
      ),

      // 👇 Aquí lo correcto
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox.shrink();

          final estados = events
              .whereType<ReservationModel>()
              .map((r) => r.estado.toUpperCase())
              .toSet();

          // 🔹 Varios estados en el mismo día → puntos multicolor
          if (estados.length > 1) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: estados.take(3).map((estado) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _estadoColor(estado),
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            );
          }

          // 🔹 Solo un estado en el día
          final color = _estadoColor(estados.first);
          return Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          );
        },
      ),
    );
  }
}