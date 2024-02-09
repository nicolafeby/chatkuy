import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/presentation/home/page/home_page.dart';
import 'package:chatkuy/presentation/profile/profile_page.dart';
import 'package:chatkuy/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';

class BasePageArg {
  final BasePageRoute route;
  const BasePageArg({required this.route});
}

enum BasePageRoute {
  chat,
  profile,
}

class BasePage extends StatefulWidget {
  final BasePageArg argument;
  const BasePage({super.key, required this.argument});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final List<IconData> _icon = [Icons.group, Icons.settings];
  int _selectedIndex = 0;
  final List<String> _titleMenu = ['Grup', 'Profile'];

  DateTime preBackPress = DateTime.now();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _selectedIndex = _convertToIndex();
    super.initState();
  }

  int _convertToIndex() {
    switch (widget.argument.route) {
      case BasePageRoute.profile:
        return _selectedIndex = 1;

      default:
        return _selectedIndex = 0;
    }
  }

  // BasePageRoute _convertToIndex(int index) {
  //   switch (widget.argument.route) {
  //     case BasePageRoute.profile:
  //       _selectedIndex = 1;
  //       break;

  //     default:
  //       _selectedIndex = 0;
  //       break;
  //   }
  // }

  Widget _buildNavigator() {
    return BottomNavigationBar(
      selectedItemColor: AppColor.primaryColor,
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

    // return Container(
    //   child: Row(
    //     children: List.generate(
    //     _titleMenu.length,
    //     (index) => BottomNavigationBarItem(
    //       label: _titleMenu[index],
    //       icon: Icon(_icon[index]),
    //     ),
    //   ),
    //   ),
    // );
  }

  Future<bool> _onWillPop() async {
    final timegap = DateTime.now().difference(preBackPress);
    final cantExit = timegap >= const Duration(seconds: 3);
    preBackPress = DateTime.now();
    if (cantExit) {
      showSnackbar(
          context, Colors.green, 'Tekan sekali lagi untuk menutup aplikasi');
      return false;
    } else {
      return true;
    }
  }

  Widget _buildPages() {
    final List<Widget> pages = <Widget>[
      const HomePage(),
      const ProfilePage(),
    ];
    return pages[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _buildPages(),
        bottomNavigationBar: _buildNavigator(),
      ),
    );
  }
}
