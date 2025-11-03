import 'package:cabinapp/features/cabins/presentation/widgets/add_cabin_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/cabins/presentation/widgets/cabin_card.dart';
import 'package:cabinapp/features/cabins/presentation/providers/cabins_provider.dart';

class CabinsPage extends StatefulWidget {
  const CabinsPage({super.key});

  @override
  State<CabinsPage> createState() => _CabinsPageState();
}

class _CabinsPageState extends State<CabinsPage> {
  @override
  void initState() {
    super.initState();
    // 🔹 Cargamos las cabañas al abrir la página
    Future.microtask(() {
      context.read<CabinsProvider>().fetchCabins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final cabinsProvider = context.watch<CabinsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(local.cabins),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Builder(
          builder: (_) {
            if (cabinsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cabinsProvider.errorMessage != null) {
              return Center(
                child: Text(
                  cabinsProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (cabinsProvider.cabins.isEmpty) {
              return Center(
                child: Text(local.noCabinsYet), // 👈 agrega este texto a tu traducción
              );
            }

            final cabins = cabinsProvider.cabins;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: cabins.length,
              itemBuilder: (context, index) {
                final cabin = cabins[index];
                return CabinCard(
                  index: index,
                  name: cabin.nombre,
                  capacity: cabin.capacidad,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: const AddCabinButton(),
    );
  }
}