import 'package:flutter/material.dart';

class LessonActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LessonActionButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        backgroundColor:
            const Color.fromRGBO(36, 36, 36, 1), // Цвет фона кнопки
        foregroundColor: Colors.white, // Белый цвет текста
      ),
      child: Text(label),
    );
  }
}
