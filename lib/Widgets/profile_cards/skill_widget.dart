import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SkillWidget extends StatelessWidget {
  final String text; // Параметр для текста (например, "Выбранное направление")

  const SkillWidget({
    super.key,
    required this.text, // Обязательный параметр для текста
  });

  // Метод для получения выбранного направления
  Future<String?> _getSelectedSkill() async {
    final logger = Logger();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || currentUser.email == null) {
      logger.d("Пользователь не авторизован или email отсутствует");
      return null;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .get();

      if (userDoc.exists) {
        final selectedSkill = userDoc['selected_skill'] as String?;
        return selectedSkill;
      } else {
        logger.d("Документ пользователя не найден");
        return null;
      }
    } catch (e) {
      logger.e('Ошибка при получении выбранного направления: $e');
      return null;
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
    double textSize =
        screenWidth * 0.04; // 4% ширины экрана для основного текста
    double descriptionTextSize =
        screenWidth * 0.03; // 3% ширины экрана для дополнительного текста

    return FutureBuilder<String?>(
      future: _getSelectedSkill(),
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

        String? selectedSkill = snapshot.data;

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
            children: [
              const SizedBox(height: 10),
              // Иконка
              Icon(
                Icons.school_rounded,
                size: iconSize,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              // Название скилла
              Text(
                selectedSkill ?? 'Не выбрано',
                style: TextStyle(
                  fontSize: textSize, // Основной текст (4% ширины экрана)
                  color: Colors.white,
                  fontWeight: FontWeight.bold, // Жирный шрифт
                ),
                textAlign: TextAlign.center, // Выравнивание по центру
                maxLines: 2, // Максимум 2 строки
                overflow: TextOverflow
                    .ellipsis, // Обрезать текст, если он слишком длинный
              ),
              const SizedBox(height: 10),
              // Описание (переданный текст)
              Text(
                text,
                style: TextStyle(
                  fontSize:
                      descriptionTextSize, // Дополнительный текст (3% ширины экрана)
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Выравнивание по центру
                maxLines: 2, // Максимум 2 строки
                overflow: TextOverflow
                    .ellipsis, // Обрезать текст, если он слишком длинный
              ),
            ],
          ),
        );
      },
    );
  }
}
