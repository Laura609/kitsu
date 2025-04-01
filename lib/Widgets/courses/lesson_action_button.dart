import 'package:flutter/material.dart';

class LessonActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LessonActionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Выравнивание по правому краю
      children: [
        SizedBox(
          width: 170, // Фиксированная ширина кнопки
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              backgroundColor:
                  const Color.fromRGBO(2, 217, 173, 1), // Цвет фона кнопки
              foregroundColor:
                  const Color.fromRGBO(43, 43, 43, 1), // Цвет текста
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Округление углов
              ),
            ),
            child: Text(label),
          ),
        ),
      ],
    );
  }
}
