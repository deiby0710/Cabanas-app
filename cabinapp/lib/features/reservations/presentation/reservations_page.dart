import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart'; 

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.reservations), // 👈 “Reservas” / “Reservations”
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('${local.reservation} #${index + 1}'),
              subtitle: Text('${local.client}: Juan Pérez'),
              trailing: Text(local.confirmed),
            ),
          );
        },
      ),
    );
  }
}
