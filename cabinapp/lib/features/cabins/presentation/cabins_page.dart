import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/cabins/presentation/widgets/cabin_card.dart';

class CabinsPage extends StatelessWidget {
  const CabinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.cabins),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: 5,
        itemBuilder: (context, index) => CabinCard(index: index), // 👈 modularizado
      ),
    );
  }
}