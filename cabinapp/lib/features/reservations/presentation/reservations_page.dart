import 'package:flutter/material.dart';

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservas')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('Reserva #${index + 1}'),
              subtitle: const Text('Cliente: Juan Pérez'),
              trailing: const Text('Confirmada'),
            ),
          );
        },
      ),
    );
  }
}
