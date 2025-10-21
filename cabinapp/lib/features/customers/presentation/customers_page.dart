import 'package:flutter/material.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Juan Pérez'),
            subtitle: Text('juanperez@example.com'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('María López'),
            subtitle: Text('marialopez@example.com'),
          ),
        ],
      ),
    );
  }
}
