import 'package:cabinapp/features/customers/presentation/widgets/add_customer_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/customers/presentation/widgets/customer_card.dart';
import 'package:cabinapp/features/customers/presentation/provider/customers_provider.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  void initState() {
    super.initState();
    // 🔹 Cargar clientes al abrir la página
    Future.microtask(() {
      context.read<CustomersProvider>().fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final customersProvider = context.watch<CustomersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(local.clients),
      ),
      body: Builder(
        builder: (_) {
          if (customersProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (customersProvider.errorMessage != null) {
            return Center(
              child: Text(
                customersProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final customers = customersProvider.customers;

          if (customers.isEmpty) {
            return Center(
              child: Text(local.noClientsYet), // 🔹 Traducción necesaria
            );
          }

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return CustomerCard(
                name: customer.nombre,
                email: customer.celular, // 👈 Mostramos el teléfono como subtítulo
                index: index,
              );
            },
          );
        },
      ),
      floatingActionButton: const AddCustomerButton(),
    );
  }
}