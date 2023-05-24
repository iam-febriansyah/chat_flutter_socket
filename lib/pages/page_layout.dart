import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat/style/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menus/menu_home.dart';
import 'menus/menu_setting.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({super.key});

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  int _selectedIndex = 0;
  String titlePage = 'Home';

  static const List<Widget> _pages = <Widget>[PageMenuHome(), PageMenuSetting()];
  static const List<String> titlePages = ['Home', 'Setting'];
  Timer? timer;
  Color conColor = ColorsTheme.hijau;

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
        titlePage = titlePages[index];
      });
    }
  }

  void checkConnection() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var con = preferences.getString("PREF_SOCKET") ?? "Not Connected";
    if (mounted) {
      setState(() {
        if (con == "Not Connected") {
          conColor = ColorsTheme.merah;
        } else if (con == "Connected") {
          conColor = ColorsTheme.hijau;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => checkConnection());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titlePage),
        backgroundColor: ColorsTheme.primary1,
        toolbarOpacity: 0,
        bottomOpacity: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4, right: 16),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: conColor,
                border: Border.all(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
