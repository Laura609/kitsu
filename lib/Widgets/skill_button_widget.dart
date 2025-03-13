import 'package:flutter/material.dart';

class SkillButton extends StatelessWidget {
  final String skill;
  final bool isSelected;
  final VoidCallback onPressed;

  const SkillButton({
    super.key,
    required this.skill,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding =
        screenWidth * 0.07; // Адаптивный горизонтальный паддинг
    double fontSize = screenWidth * 0.04; // Адаптивный размер шрифта

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        width: double.infinity, // Ширина на всю доступную область
        height: 50, // Фиксированная высота
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent, // Прозрачный фон
            side: BorderSide(
              color: isSelected
                  ? const Color.fromRGBO(
                      2, 217, 173, 1) // Цвет контура при выборе
                  : const Color.fromRGBO(
                      103, 103, 103, 1), // Цвет контура без выбора
              width: 2, // Толщина контура
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Закругление углов
            ),
          ),
          child: Text(
            skill,
            style: TextStyle(
              color: isSelected
                  ? const Color.fromRGBO(
                      2, 217, 173, 1) // Цвет текста при выборе
                  : Colors.white, // Цвет текста без выбора
              fontSize: fontSize, // Адаптивный размер шрифта
            ),
          ),
        ),
      ),
    );
  }
}
