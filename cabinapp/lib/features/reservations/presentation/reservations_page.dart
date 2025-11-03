import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/reservations_calendar.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/reservations_status_row.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/reservation_card.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, dynamic>>> _reservations = {
    DateTime.utc(2025, 11, 3): [
      {'name': 'Cabaña del Lago', 'capacity': 8, 'reserved': false},
      {'name': 'El Refugio', 'capacity': 6, 'reserved': true},
    ],
  };

  List<Map<String, dynamic>> _getReservationsForDay(DateTime day) {
    return _reservations[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final selectedReservations = _getReservationsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.reservations),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ReservationsCalendar(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            eventLoader: _getReservationsForDay,
          ),
          const SizedBox(height: 10),
          ReservationsStatusRow(),
          const SizedBox(height: 10),
          Expanded(
            child: selectedReservations.isEmpty
                ? Center(child: Text(local.noReservationsForThisDay))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: selectedReservations.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final cabin = selectedReservations[index];
                      return ReservationCard(
                        name: cabin['name'],
                        capacity: cabin['capacity'],
                        reserved: cabin['reserved'],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}