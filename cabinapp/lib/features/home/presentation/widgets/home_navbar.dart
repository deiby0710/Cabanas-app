import 'package:flutter/material.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class HomeNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!; // 👈 Acceso a las traducciones

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: local.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.cabin),
          label: local.cabins,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_month),
          label: local.reservations,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.people),
          label: local.clients, 
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: local.settingsTitle,
        ),
      ],
    );
  }
}