import 'package:flutter/material.dart';
import 'diet_page.dart';
import 'fasting_page.dart';
import 'workout_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const DietPage(),
    const FastingPage(),
    const WorkoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu), 
            label: 'Diet'
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt), 
            label: 'Puasa'
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center), 
            label: 'Olahraga'
          ),
        ],
      ),
    );
  }
}