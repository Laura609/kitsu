import 'package:flutter/material.dart';
import 'package:test1/Pages/home_page.dart';
import 'package:test1/Pages/mentor_or_student_profile_page.dart';
import 'package:test1/Pages/training_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 2; // Изначально выбран профиль (номер 2)

  // Маппинг маршрутов
  final List<String> _routes = [
    TrainingPage.routeName, // Страница обучения
    HomePage.routeName, // Главная страница
    MentorOrStudentPofilePage.routeName, // Страница профиля
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(43, 43, 43, 1),
      selectedItemColor: const Color.fromRGBO(48, 127, 245, 1),
      unselectedItemColor: const Color.fromRGBO(173, 174, 174, 1),
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: "Обучение", // Страница обучения
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Главная", // Главная страница
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Профиль", // Страница профиля
        ),
      ],
      onTap: (int index) {
        // Обновляем выбранный индекс
        setState(() {
          _selectedIndex = index;
        });

        // Навигация на соответствующую страницу
        if (_routes[index] != ModalRoute.of(context)?.settings.name) {
          Navigator.pushReplacementNamed(context, _routes[index]);
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Получаем текущий маршрут и устанавливаем индекс
    final routeName = ModalRoute.of(context)?.settings.name;

    if (routeName == TrainingPage.routeName) {
      _selectedIndex = 0; // Обучение
    } else if (routeName == HomePage.routeName) {
      _selectedIndex = 1; // Главная
    } else if (routeName == MentorOrStudentPofilePage.routeName) {
      _selectedIndex = 2; // Профиль
    }
  }
}
