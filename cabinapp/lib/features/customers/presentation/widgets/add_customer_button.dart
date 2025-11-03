import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCustomerButton extends StatelessWidget {
  const AddCustomerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: () => context.push('/customers/create'),
      backgroundColor: theme.colorScheme.primary,
      child: const Icon(
        Icons.person_add,
        color: Colors.white,
      ),
    );
  }
}