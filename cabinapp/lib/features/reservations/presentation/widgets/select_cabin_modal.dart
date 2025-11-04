import 'package:cabinapp/features/cabins/data/cabins_repository.dart';
import 'package:flutter/material.dart';

class SelectCabinModal extends StatefulWidget {
  const SelectCabinModal({super.key});

  @override
  State<SelectCabinModal> createState() => _SelectCabinModalState();
}

class _SelectCabinModalState extends State<SelectCabinModal> {
  late Future<List<CabinItem>> _futureCabins;
  List<CabinItem> _filteredCabins = [];

  @override
  void initState() {
    super.initState();
    _futureCabins = _loadCabins();
  }

  Future<List<CabinItem>> _loadCabins() async {
    final repo = CabinsRepository();
    final cabinsData = await repo.getCabins(); // 🔹 debes implementar esto
    final cabins = cabinsData
        .map((c) => CabinItem(
              id: c.id,
              name: c.nombre,
              capacity: c.capacidad,
            ))
        .toList();
    _filteredCabins = cabins;
    return cabins;
  }

  void _filterCabins(String query, List<CabinItem> allCabins) {
    setState(() {
      _filteredCabins = allCabins
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.capacity.toString().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar cabaña'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<CabinItem>>(
        future: _futureCabins,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay cabañas disponibles'));
          }

          final cabins = snapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar cabaña...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (query) => _filterCabins(query, cabins),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCabins.length,
                  itemBuilder: (context, index) {
                    final cabin = _filteredCabins[index];
                    return ListTile(
                      leading: const Icon(Icons.cabin, color: Colors.brown),
                      title: Text(
                        cabin.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('Capacidad: ${cabin.capacity}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Navigator.pop(context, cabin),
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

class CabinItem {
  final int id;
  final String name;
  final int capacity;

  CabinItem({
    required this.id,
    required this.name,
    required this.capacity,
  });
}