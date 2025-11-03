import 'package:flutter/material.dart';

class SelectCabinModal extends StatefulWidget {
  final List<CabinItem> cabins;

  const SelectCabinModal({
    super.key,
    required this.cabins,
  });

  @override
  State<SelectCabinModal> createState() => _SelectCabinModalState();
}

class _SelectCabinModalState extends State<SelectCabinModal> {
  late List<CabinItem> filteredCabins;

  @override
  void initState() {
    super.initState();
    filteredCabins = widget.cabins;
  }

  void _filterCabins(String query) {
    setState(() {
      filteredCabins = widget.cabins
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
      body: Column(
        children: [
          // 🔹 Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar cabaña...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterCabins,
            ),
          ),

          // 🔹 Lista de cabañas
          Expanded(
            child: ListView.builder(
              itemCount: filteredCabins.length,
              itemBuilder: (context, index) {
                final cabin = filteredCabins[index];
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
      ),
    );
  }
}

// 🔹 Modelo simplificado de cabaña (solo para el modal)
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