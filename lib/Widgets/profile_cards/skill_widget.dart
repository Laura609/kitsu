import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/loading_widget.dart';

class SkillWidget extends StatelessWidget {
  final String text; // Параметр для текста
  final String email; // Параметр для email выбранного пользователя

  const SkillWidget({
    super.key,
    required this.text,
    required this.email, // Обязательный параметр для email
  });

  // Метод для получения выбранного направления
  Future<String?> _getSelectedSkill() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();

      if (userDoc.exists) {
        final selectedSkill = userDoc['selected_skill'] as String?;
        return selectedSkill;
      } else {
        return null;
      }
    } catch (e) {
      return null; // В случае ошибки просто возвращаем null
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
    double textSize = screenWidth * 0.04;
    double descriptionTextSize = screenWidth * 0.03;

    return FutureBuilder<String?>(
      future: _getSelectedSkill(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }

        // Если данных нет или произошла ошибка, показываем "Не выбрано"
        String? selectedSkill = snapshot.data ?? 'Не выбрано';

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
                selectedSkill,
                style: TextStyle(
                  fontSize: textSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              // Описание (переданный текст)
              Text(
                text,
                style: TextStyle(
                  fontSize: descriptionTextSize,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
