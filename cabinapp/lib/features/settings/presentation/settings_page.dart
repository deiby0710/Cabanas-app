import 'package:cabinapp/features/settings/presentation/widgets/created_by_label.dart';
import 'package:cabinapp/features/settings/presentation/widgets/organization_button.dart';
import 'package:flutter/material.dart';
import 'package:cabinapp/features/settings/presentation/widgets/logout_button.dart';
import 'package:cabinapp/features/settings/presentation/widgets/theme_button.dart';
import 'package:cabinapp/features/settings/presentation/widgets/user_info_card.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.settingsTitle),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const UserInfoCard(),

            const SizedBox(height: 30),

            const OrganizationButton(),

            const SizedBox(height: 30),

            const LogoutButton(),

            const SizedBox(height: 40),

            const CreatedByLabel(),
          ],
        ),
      ),
    );
  }
}