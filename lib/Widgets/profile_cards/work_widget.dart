import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MentorStudentCountWidget extends StatelessWidget {
  final String text; // Параметр для текста
  final IconData icon; // Параметр для иконки

  const MentorStudentCountWidget({
    super.key,
    required this.text, // Обязательный параметр для текста
    required this.icon, // Обязательный параметр для иконки
  });

  // Метод для получения количества студентов
  Future<int> _getStudentCount() async {
    final logger = Logger();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('isLearning', isEqualTo: true)
          .get();

      return snapshot.size; // Возвращаем количество студентов
    } catch (e) {
      logger.e('Ошибка при получении количества студентов: $e');
      return 0; // Возвращаем 0 в случае ошибки
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
      future: _getStudentCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Обрабатываем ошибку, если она возникла, или если данные отсутствуют
        int studentCount =
            snapshot.hasError || !snapshot.hasData ? 0 : snapshot.data ?? 0;

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
                icon, // Используем переданную иконку
                size: iconSize,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                '$studentCount',
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
