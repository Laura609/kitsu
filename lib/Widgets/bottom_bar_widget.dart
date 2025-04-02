import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:test1/router/router.gr.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 3; // Начинаем с профиля

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(43, 43, 43, 1),
      selectedItemColor: const Color.fromRGBO(2, 217, 173, 1),
      unselectedItemColor: const Color.fromRGBO(173, 174, 174, 1),
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Друзья"),
        BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: "Чат"),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), label: "Профиль"),
      ],
      onTap: (int index) {
        if (index == _selectedIndex) return;

        setState(() {
          _selectedIndex = index;
        });

        _navigateToRoute(index);
      },
    );
  }

  void _navigateToRoute(int index) {
    switch (index) {
      case 0:
        context.replaceRoute(const HomeRoute());
        break;
      case 1:
        context.replaceRoute(const FriendsRoute());
        break;
      case 2:
        context.replaceRoute(ChatsRoute());
        break;
      case 3:
        context.replaceRoute(const MentorOrStudentProfileRoute());
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final currentRoute = context.router.current.name;
    if (currentRoute == HomeRoute.name) {
      _selectedIndex = 0;
    } else if (currentRoute == FriendsRoute.name) {
      _selectedIndex = 1;
    } else if (currentRoute == ChatsRoute.name) {
      _selectedIndex = 2;
    } else if (currentRoute == MentorOrStudentProfileRoute.name) {
      _selectedIndex = 3;
    }
  }
}
