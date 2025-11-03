import 'package:flutter/material.dart';
import 'package:cabinapp/features/cabins/presentation/widgets/create_cabin_form.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class CreateCabinPage extends StatelessWidget {
  const CreateCabinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.addCabin),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CreateCabinForm(), // 👈 Modularizado
        ),
      ),
    );
  }
}