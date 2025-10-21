import 'package:flutter/material.dart';

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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.cabin), label: 'Cabañas'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Reservas'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clientes'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
      ],
    );
  }
}