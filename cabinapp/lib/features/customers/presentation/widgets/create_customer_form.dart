import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/customers/presentation/provider/customers_provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class CreateCustomerForm extends StatefulWidget {
  const CreateCustomerForm({super.key});

  @override
  State<CreateCustomerForm> createState() => _CreateCustomerFormState();
}

class _CreateCustomerFormState extends State<CreateCustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<CustomersProvider>();
    final local = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    try {
      await provider.createCustomer(
        _nameController.text.trim(),
        _phoneController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.customerCreated)),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final provider = context.watch<CustomersProvider>();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Título
              Text(
                local.createClientTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),

              // 🔹 Nombre
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: local.clientNameLabel,
                  prefixIcon: const Icon(Icons.person_outline),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? local.enterClientName : null,
              ),
              const SizedBox(height: 20),

              // 🔹 Celular
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: local.clientPhoneLabel,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? local.enterPhone : null,
              ),
              const SizedBox(height: 30),

              // 🔹 Botón
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(local.createClient),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}