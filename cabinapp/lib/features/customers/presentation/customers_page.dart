import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/customers/presentation/widgets/customer_card.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    // 🔹 Simulación temporal (mock data)
    final customers = [
      {'name': 'Juan Pérez', 'email': 'juanperez@example.com'},
      {'name': 'María López', 'email': 'marialopez@example.com'},
      {'name': 'Carlos Gómez', 'email': 'carlosgomez@example.com'},
      {'name': 'Ana Torres', 'email': 'anatorres@example.com'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(local.clients),
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return CustomerCard(
            name: customer['name']!,
            email: customer['email']!,
            index: index,
          );
        },
      ),
    );
  }
}
