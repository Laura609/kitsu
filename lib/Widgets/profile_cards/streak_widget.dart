import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakWidget extends StatelessWidget {
  final String text; // Параметр для текста

  const StreakWidget({
    super.key,
    required this.text, // Обязательный параметр для текста
  });

  // Метод для получения текущего стрика
  Future<int> _getStreakCount(String email) async {
    final logger = Logger();
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();

      if (userDoc.exists) {
        return (userDoc.data() as Map<String, dynamic>)['streakCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      logger.e('Ошибка при получении стрика: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Вычисляем размеры элементов относительно экрана
    double containerWidth = screenWidth * 0.3; // 30% ширины экрана
    double containerHeight = screenHeight * 0.16; // 12% высоты экрана
    double iconSize = screenWidth * 0.1; // 10% ширины экрана для иконки
    double textSize = screenWidth * 0.05; // 5% ширины экрана для текста

    // Получаем текущего пользователя
    final currentUser = FirebaseAuth.instance.currentUser;
    final email = currentUser?.email;

    return FutureBuilder<int>(
      future: email != null ? _getStreakCount(email) : Future.value(0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ошибка: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final streakCount = snapshot.data ?? 0;

        // Цвет иконки: желтый, если стрик > 0, иначе белый
        final iconColor = streakCount > 0
            ? const Color.fromRGBO(2, 217, 173, 1)
            : Colors.white;

        return Container(
          height: containerHeight,
          width: containerWidth,
          margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(47, 47, 47, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Иконка
              Icon(
                Icons
                    .local_fire_department_rounded, // Используем переданную иконку
                size: iconSize,
                color: iconColor, // Цвет иконки зависит от стрика
              ),
              const SizedBox(height: 10),
              Text(
                '$streakCount', // Отображаем текущий стрик
                style: TextStyle(
                  fontSize: textSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text, // Используем переданный текст
                style: TextStyle(
                  fontSize: textSize * 0.6,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
