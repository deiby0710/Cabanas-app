import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cabinapp/features/cabins/presentation/providers/cabins_provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class AddCabinButton extends StatelessWidget {
  const AddCabinButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    return FloatingActionButton(
      onPressed: () async {
        // 🔹 Navegamos con GoRouter a la página de creación
        await context.push('/createCabin');

        // 🔄 Al volver, actualizamos la lista de cabañas
        if (context.mounted) {
          context.read<CabinsProvider>().fetchCabins();
        }
      },
      tooltip: local.addCabin, // 👈 texto accesible al mantener presionado
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4,
      child: const Icon(Icons.add), // 👈 solo el ícono
    );
  }
}