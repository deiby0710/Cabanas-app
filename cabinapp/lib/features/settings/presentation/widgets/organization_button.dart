import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class OrganizationButton extends StatelessWidget {
  const OrganizationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            context.push('/selectOrganization');
          },
          icon: Icon(
            Icons.business_outlined,
            color: theme.colorScheme.primary,
          ),
          label: Text(
            local.changeOrganization,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}