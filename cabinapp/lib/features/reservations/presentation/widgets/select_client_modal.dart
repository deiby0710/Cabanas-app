import 'package:cabinapp/features/customers/data/customers_repository.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SelectClientModal extends StatefulWidget {
  const SelectClientModal({super.key});

  @override
  State<SelectClientModal> createState() => _SelectClientModalState();
}

class _SelectClientModalState extends State<SelectClientModal> {
  late Future<List<ClientItem>> _futureClients;
  List<ClientItem> _filteredClients = [];

  @override
  void initState() {
    super.initState();
    _futureClients = _loadClients();
  }

  Future<List<ClientItem>> _loadClients() async {
    final repo = CustomersRepository();
    final clientsData = await repo.getCustomers();
    final clients = clientsData
        .map((c) => ClientItem(
              id: c.id,
              name: c.nombre,
              phone: c.celular,
            ))
        .toList();
    _filteredClients = clients;
    return clients;
  }

  void _filterClients(String query, List<ClientItem> allClients) {
    setState(() {
      _filteredClients = allClients
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.phone.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.selectClientLabel),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: FutureBuilder<List<ClientItem>>(
        future: _futureClients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(local.noClientsAvailable));
          }

          final clients = snapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: local.searchClientPlaceholder,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (query) => _filterClients(query, clients),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredClients.length,
                  itemBuilder: (context, index) {
                    final client = _filteredClients[index];
                    return ListTile(
                      leading:
                          const Icon(Icons.person, color: Colors.blueAccent),
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
          );
        },
      ),
    );
  }
}

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