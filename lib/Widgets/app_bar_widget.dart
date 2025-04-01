import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Auth/auth_page.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;
  final String text;
  final bool showSignOutButton; // Новый параметр для кнопки выхода
  final Color backgroundColor; // Параметр для выбора цвета фона
  final Color textColor; // Параметр для выбора цвета текста

  const AppBarWidget({
    super.key,
    required this.text,
    required this.isBack,
    this.showSignOutButton = false, // По умолчанию кнопка не показывается
    this.backgroundColor =
        const Color.fromRGBO(43, 43, 43, 1), // Цвет фона по умолчанию
    this.textColor = Colors.white, // Цвет текста по умолчанию (белый)
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor, // Используем переданный цвет фона
      leading: isBack
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white, // Иконка назад белая
              ),
              onPressed: () {
                // Действие для кнопки назад
                Navigator.pop(context);
              },
            )
          : null, // Нет кнопки назад, если isBack = false
      title: Text(
        text,
        style: TextStyle(
          color: textColor, // Используем переданный цвет текста
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true, // Центрирование текста
      actions: showSignOutButton
          ? [
              IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white, // Белая иконка выхода
                ),
                onPressed: () {
                  // Действие для кнопки выхода
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthPage(),
                    ),
                  );
                },
              ),
            ]
          : [], // Если кнопка выхода не должна отображаться
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Высота AppBar по умолчанию
}
