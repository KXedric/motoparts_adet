import 'package:flutter/material.dart';
import 'package:motoparts_manager/screens/dashboard/dashboard_screen.dart';
import 'package:motoparts_manager/screens/motorcycle_profile/motorcycle_profile_screen.dart';
import 'package:motoparts_manager/screens/parts_inventory/parts_inventory_screen.dart';
import 'package:motoparts_manager/screens/add_edit_part/add_edit_part_screen.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(
        onMotorcycleTap: () => setState(() => _currentIndex = 1),
        onInventoryTap: () => setState(() => _currentIndex = 2),
      ),
      const MotorcycleProfileScreen(),
      const PartsInventoryScreen(),
    ];
  }

  void _onDestinationSelected(int index) {
    if (index == 3) {
      // Add Part tab - push route instead of switching tab
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AddEditPartScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.two_wheeler_outlined),
            selectedIcon: Icon(Icons.two_wheeler),
            label: 'My Bike',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Add Part',
          ),
        ],
      ),
    );
  }
}
