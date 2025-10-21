import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart'; // 👈 Import necesario

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!; 

    return Scaffold(
      appBar: AppBar(
        title: Text(local.clients),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Juan Pérez'),
            subtitle: Text('juanperez@example.com'),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('María López'),
            subtitle: Text('marialopez@example.com'),
          ),
        ],
      ),
    );
  }
}