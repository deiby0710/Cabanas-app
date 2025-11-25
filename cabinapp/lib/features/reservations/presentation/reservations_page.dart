import 'package:cabinapp/features/reservations/presentation/widgets/reservations_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/reservations/presentation/provider/reservation_provider.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/reservation_card.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/reservations_status_row.dart';
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
  // Este metodo solo se ejecuta una vez cuando se crea el state del widget (antes del primer build)
  void initState() {
    super.initState();
    // Crea una tarea asincronica 
    Future.microtask(() {
      // Obtenemos una instancia de ReservationsProvider y llama a su metodo fetchReservations
      context.read<ReservationsProvider>().fetchReservations();
    });
  }
  // Resumen -> Cuando la pagina se crea, se programa una tarea inmediata para pedir al reservation 
  // provider que cargue las reservas desde el back end una sola vez al inicio

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final provider = context.watch<ReservationsProvider>();

    // 🔹 Filtramos las reservas según el día seleccionado
    final filteredReservations = provider.reservations.where((r) {
    // 🔹 Normalizamos todas las fechas a la zona local
    final start = DateTime(
      r.fechaInicio.toLocal().year,
      r.fechaInicio.toLocal().month,
      r.fechaInicio.toLocal().day,
    );

    final end = DateTime(
      r.fechaFin.toLocal().year,
      r.fechaFin.toLocal().month,
      r.fechaFin.toLocal().day,
    );

    final selected = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );

    // 🔹 Comprobamos si el día seleccionado está dentro del rango
    final coincide = !selected.isBefore(start) && selected.isBefore(end);

    return coincide;
  }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(local.reservations),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
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
              final reservasDelDia = provider.reservations.where((r) {
                final start = DateTime(r.fechaInicio.toLocal().year, r.fechaInicio.toLocal().month, r.fechaInicio.toLocal().day);
                final end   = DateTime(r.fechaFin.toLocal().year, r.fechaFin.toLocal().month, r.fechaFin.toLocal().day);
                final selected = DateTime(day.year, day.month, day.day);

                final coincide = !selected.isBefore(start) && selected.isBefore(end);

                return coincide;
              }).toList();

              return reservasDelDia;
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
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary,),
      ),
    );
  }
}