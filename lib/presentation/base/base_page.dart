import 'package:chatkuy/presentation/home/page/home_page.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final List<String> _titleMenu = ['Grup', 'Profile'];
  final List<IconData> _icon = [Icons.group, Icons.settings];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPages(),
      bottomNavigationBar: _buildNavigator(),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavigator() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: List.generate(
        _titleMenu.length,
        (index) => BottomNavigationBarItem(
          label: _titleMenu[index],
          icon: Icon(_icon[index]),
        ),
      ),
    );
  }

  Widget _buildPages() {
    final List<Widget> pages = <Widget>[
      const HomePage(),
      // ProfilePage(argument: argument)
    ];
    return pages[_selectedIndex];
  }
}
