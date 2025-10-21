import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/core/theme/theme_provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart'; // 👈 Import necesario

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final local = AppLocalizations.of(context)!; // 👈 Acceso a traducciones

    return IconButton(
      tooltip: isDark 
          ? local.lightMode
          : local.darkMode,
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: Theme.of(context).colorScheme.onSurface,
        size: 30,
      ),
      onPressed: () {
        themeProvider.toggleTheme();
      },
    );
  }
}
