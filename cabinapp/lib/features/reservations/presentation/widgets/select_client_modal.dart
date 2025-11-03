import 'package:flutter/material.dart';

class SelectClientModal extends StatefulWidget {
  final List<ClientItem> clients;

  const SelectClientModal({
    super.key,
    required this.clients,
  });

  @override
  State<SelectClientModal> createState() => _SelectClientModalState();
}

class _SelectClientModalState extends State<SelectClientModal> {
  late List<ClientItem> filteredClients;

  @override
  void initState() {
    super.initState();
    filteredClients = widget.clients;
  }

  void _filterClients(String query) {
    setState(() {
      filteredClients = widget.clients
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.phone.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar cliente'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 🔹 Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar cliente...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterClients,
            ),
          ),

          // 🔹 Lista de clientes
          Expanded(
            child: ListView.builder(
              itemCount: filteredClients.length,
              itemBuilder: (context, index) {
                final client = filteredClients[index];
                return ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueAccent),
                  title: Text(
                    client.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(client.phone),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.pop(context, client),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Modelo simplificado de cliente (solo para el modal)
class ClientItem {
  final int id;
  final String name;
  final String phone;

  ClientItem({
    required this.id,
    required this.name,
    required this.phone,
  });
}