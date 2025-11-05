import 'package:cabinapp/features/reservations/presentation/widgets/reservations_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/reservations/presentation/provider/reservation_provider.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/reservation_card.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/reservations_status_row.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ReservationsProvider>().fetchReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final provider = context.watch<ReservationsProvider>();

    // 🔹 Filtramos las reservas según el día seleccionado
    final filteredReservations = provider.reservations.where((r) {
      final start = DateTime(r.fechaInicio.year, r.fechaInicio.month, r.fechaInicio.day);
      final end = DateTime(r.fechaFin.year, r.fechaFin.month, r.fechaFin.day);
      final selected = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

      // ✅ Ocupada desde fechaInicio hasta el día ANTERIOR a fechaFin
      return !selected.isBefore(start) && selected.isBefore(end);
    }).toList();


    return Scaffold(
      appBar: AppBar(
        title: Text(local.reservations),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 🔹 Calendario
          ReservationsCalendar(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return provider.reservations.where((r) {
                final start = DateTime(r.fechaInicio.year, r.fechaInicio.month, r.fechaInicio.day);
                final end = DateTime(r.fechaFin.year, r.fechaFin.month, r.fechaFin.day);
                final selected = DateTime(day.year, day.month, day.day);
                return !selected.isBefore(start) && selected.isBefore(end);
              }).toList();
            },
          ),

          const SizedBox(height: 8),
          const ReservationsStatusRow(),
          const SizedBox(height: 12),

          Expanded(
            child: Builder(
              builder: (_) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (filteredReservations.isEmpty) {
                  return Center(
                    child: Text(local.noReservationsForThisDay),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: filteredReservations.length,
                  itemBuilder: (context, index) {
                    final reservation = filteredReservations[index];
                    return ReservationCard(
                      name: reservation.cabanaNombre,
                      capacity: reservation.cabanaCapacidad ?? 0,
                      status: reservation.estado,
                      index: index,
                      reservationModel: reservation,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await context.push<bool>(
            '/reservations/create',
            extra: _selectedDay,
          );

          if (created == true && mounted) {
            await context.read<ReservationsProvider>().fetchReservations();
            setState(() {}); // fuerza redibujo de la UI
          }
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}