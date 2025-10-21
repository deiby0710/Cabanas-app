import 'package:flutter/material.dart';
import 'package:cabinapp/features/home/presentation/widgets/home_navbar.dart';
import 'package:cabinapp/features/cabins/presentation/cabins_page.dart';
import 'package:cabinapp/features/reservations/presentation/reservations_page.dart';
import 'package:cabinapp/features/customers/presentation/customers_page.dart';
import 'package:cabinapp/features/settings/presentation/settings_page.dart';
import 'package:cabinapp/features/organization/presentation/organization_overview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = const [
    OrganizationOverviewPage(), // lo que ya tenías en Home
    CabinsPage(),
    ReservationsPage(),
    CustomersPage(),
    SettingsPage(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: HomeNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
