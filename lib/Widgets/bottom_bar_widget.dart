import 'package:flutter/material.dart';
import 'package:test1/Pages/home_page.dart';
import 'package:test1/Pages/mentor_or_student_profile_page.dart';
import 'package:test1/Pages/training_page.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(43, 43, 43, 1),
      selectedItemColor: const Color.fromRGBO(48, 127, 245, 1),
      unselectedItemColor: const Color.fromRGBO(173, 174, 174, 1),
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex(context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: "Обучение", // Первая кнопка - TrainingPage
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Главная", // Вторая кнопка - HomePage
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Профиль", // Третья кнопка - ProfilePage
        ),
      ],
      onTap: (int index) {
        if (index != _selectedIndex(context)) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                  context, TrainingPage.routeName); // TrainingPage
              break;
            case 1:
              Navigator.pushReplacementNamed(
                  context, HomePage.routeName); // HomePage
              break;
            case 2:
              Navigator.pushReplacementNamed(
                  context, MentorOrStudentPofilePage.routeName); // ProfilePage
              break;
            default:
              break;
          }
        }
      },
    );
  }

  int _selectedIndex(BuildContext context) {
    final routeName = ModalRoute.of(context)!.settings.name;
    if (routeName == TrainingPage.routeName) {
      return 0; // Первая кнопка - TrainingPage
    } else if (routeName == HomePage.routeName) {
      return 1; // Вторая кнопка - HomePage
    } else if (routeName == MentorOrStudentPofilePage.routeName) {
      return 2; // Третья кнопка - ProfilePage
    }
    return 0; // Default selection
  }
}
