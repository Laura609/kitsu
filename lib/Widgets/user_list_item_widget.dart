import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onTap;

  const UserListItem({required this.user, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 55,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(53, 51, 51, 1), // Фон
          borderRadius: BorderRadius.circular(30), // Закругление углов
        ),
        child: Row(
          children: [
            // Фото профиля слева
            CircleAvatar(
              radius: 20, // Подкорректирован радиус для соответствия высоте
              backgroundImage: NetworkImage(user['photoUrl'] ??
                  'https://www.example.com/default_image.jpg'),
            ),
            const SizedBox(width: 16),
            // Имя пользователя справа
            Expanded(
              child: Text(
                user['username'] ?? 'Без имени',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
