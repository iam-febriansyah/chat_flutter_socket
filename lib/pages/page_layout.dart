import 'dart:async';

import 'package:chat/controllers/ctrl.dart';
import 'package:chat/controllers/ctrl_socket.dart';
import 'package:chat/pages/menus/menu_home.dart';
import 'package:chat/pages/menus/menu_setting.dart';
import 'package:flutter/material.dart';
import 'package:chat/style/color.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({super.key});

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  CtrlSocket ctrlSocket = Get.put(CtrlSocket());
  int _selectedIndex = 0;
  String titlePage = 'Chats';

  static const List<Widget> _pages = <Widget>[PageMenuHome(), PageMenuSetting()];
  static const List<String> titlePages = ['Chats', 'Account'];
  Timer? timer;

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
        titlePage = titlePages[index];
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Ctrl>(builder: (ctrl) {
      return FocusDetector(
        onFocusLost: () {
          ctrlSocket.emitStatusOnline('onFocusLost');
        },
        onFocusGained: () {
          ctrlSocket.emitStatusOnline('onFocusGained');
        },
        onVisibilityLost: () {
          ctrlSocket.emitStatusOnline('onVisibilityLost');
        },
        onVisibilityGained: () {
          ctrlSocket.emitStatusOnline('onVisibilityGained');
        },
        onForegroundLost: () {
          ctrlSocket.emitStatusOnline('onForegroundLost');
        },
        onForegroundGained: () {
          ctrlSocket.emitStatusOnline('onForegroundGained');
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              titlePage,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: ColorsTheme.primary1,
            toolbarOpacity: 0,
            bottomOpacity: 0,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 16),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ctrl.conColor,
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
            unselectedItemColor: ColorsTheme.primary1.withOpacity(0.3),
            selectedItemColor: ColorsTheme.primary1,
            unselectedFontSize: 14,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_rounded,
                    color: ColorsTheme.primary1,
                  ),
                  label: 'Chats',
                  backgroundColor: Colors.green),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2, color: ColorsTheme.primary1),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      );
    });
  }
}
