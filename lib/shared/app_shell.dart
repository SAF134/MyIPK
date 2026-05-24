import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/calculator/calculator_screen.dart';
import '../features/schedule/schedule_screen.dart';
import '../features/task/task_screen.dart';
import 'widgets/app_bottom_nav.dart';

/// Main application shell that hosts the [BottomNavigationBar]
/// and manages tab switching with preserved state.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(key: ValueKey('home_${DateTime.now().millisecondsSinceEpoch}')),
      const CalculatorScreen(),
      const ScheduleScreen(),
      const TaskScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
