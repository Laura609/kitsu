import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_bar_widget.dart';

class UserProfileWidget extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserProfileWidget({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(36, 36, 36, 1), // Фон
      appBar: AppBarWidget(
        text: user['username'] ?? 'Профиль пользователя',
        isBack: true, // Включаем кнопку назад
        showSignOutButton: true, // Показываем кнопку выхода
      ),
      body: Center(
        // Центрируем весь контент
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Вертикальное выравнивание по центру
            crossAxisAlignment: CrossAxisAlignment
                .center, // Горизонтальное выравнивание по центру
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Имя: ${user['username'] ?? 'Не указано'}',
                style: TextStyle(
                  color: Colors.white, // Белый цвет текста
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Био: ${user['bio'] ?? 'Нет информации'}',
                style: TextStyle(
                  color: Colors.white70, // Светлый цвет для био
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Роль: ${user['role'] ?? 'Не указана'}',
                style: TextStyle(
                  color: Color.fromRGBO(2, 217, 173, 1), // Цвет роли
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
