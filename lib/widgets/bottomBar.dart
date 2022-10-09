// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:projeto_1/widgets/historicMeasure.dart';

class BottomNav extends StatefulWidget {
  int _selectedTab = 0;

  BottomNav({super.key, required int selectedTab}) {
    _selectedTab = selectedTab;
  }

  @override
  // ignore: no_logic_in_create_state
  State<BottomNav> createState() => _BottomNavState(_selectedTab);
}

class _BottomNavState extends State<BottomNav> {
  _BottomNavState(int selectedTab) {
    _selectedIndex = selectedTab;
  }
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, '/home');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/historic');
      } else {
        Navigator.pushNamed(context, '/tasks');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: 'IMC',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Histórico',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Tarefas',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
