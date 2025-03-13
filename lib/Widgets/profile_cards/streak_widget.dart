import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test1/Widgets/loading_widget.dart';

class StreakWidget extends StatelessWidget {
  final String text; // Параметр для текста
  final String email; // Параметр для email выбранного пользователя

  const StreakWidget({
    super.key,
    required this.text,
    required this.email, // Обязательный параметр для email
  });

  Future<void> initializeStreak() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        if (!userData.containsKey('streakCount')) {
          await userDoc.reference.update({'streakCount': 0}); // Инициализация
        }
      }
    } catch (e) {
      log('Ошибка при инициализации стрика: $e');
    }
  }

  // Метод для получения текущего стрика
  Future<int> _getStreakCount() async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;

        // Проверяем, существует ли поле streakCount, если нет — инициализируем его
        if (!userData.containsKey('streakCount')) {
          await userDoc.reference.update({'streakCount': 0});
          return 0; // Инициализация стрика
        }

        return userData['streakCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      log('Ошибка при получении стрика: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Вычисляем размеры элементов относительно экрана
    double containerWidth = screenWidth * 0.3;
    double containerHeight = screenHeight * 0.16;
    double iconSize = screenWidth * 0.1;
    double textSize = screenWidth * 0.05;

    return FutureBuilder<int>(
      future: _getStreakCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
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
                Icons.local_fire_department_rounded,
                size: iconSize,
                color: iconColor,
              ),
              const SizedBox(height: 10),
              Text(
                '$streakCount',
                style: TextStyle(
                  fontSize: textSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text,
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
