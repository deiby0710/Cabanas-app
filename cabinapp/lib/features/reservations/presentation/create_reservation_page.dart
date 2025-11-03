import 'package:cabinapp/features/reservations/presentation/widgets/create_reservation_form.dart';
import 'package:flutter/material.dart';

class CreateReservationPage extends StatelessWidget {
  const CreateReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva reserva'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CreateReservationForm(),
      ),
    );
  }
}