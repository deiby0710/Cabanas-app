import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/customers/presentation/widgets/create_customer_form.dart';

class CreateCustomerPage extends StatelessWidget {
  const CreateCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.addClient),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: const CreateCustomerForm(),
      ),
    );
  }
}