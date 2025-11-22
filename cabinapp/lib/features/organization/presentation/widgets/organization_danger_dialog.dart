import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class OrganizationDangerDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;

  const OrganizationDangerDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title, style: theme.textTheme.titleLarge),
      content: Text(description, style: theme.textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(local.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.errorContainer,
            foregroundColor: theme.colorScheme.onErrorContainer,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}