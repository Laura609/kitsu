import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonName;
  final Color buttonColor; // Изменено на Color для более строгой типизации
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onPressed; // Добавлено поле для onPressed

  const ButtonWidget({
    super.key,
    required this.buttonName,
    required this.buttonColor,
    this.boxShadow,
    this.onPressed, // Добавлено поле для onPressed
  });

  @override
  Widget build(BuildContext context) {
    // ширина экрана
    double screenWidth = MediaQuery.of(context).size.width;

    // размеры кнопки в зависимости от ширины экрана
    double buttonWidth = screenWidth * 0.8; // Кнопка 80% от ширины экрана
    double buttonHeight =
        screenWidth * 0.12; // Высота кнопки пропорциональна ширине

    return GestureDetector(
      onTap: onPressed, // Обработка нажатия на кнопку
      child: Container(
        width: buttonWidth, // адаптивная ширину
        height: buttonHeight, // адаптивная высоту
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: buttonColor,
          boxShadow: boxShadow,
        ),
        child: Center(
          child: Text(
            buttonName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:
                  screenWidth * 0.04, // Размер шрифта зависит от ширины экрана
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(246, 246, 246, 1),
            ),
          ),
        ),
      ),
    );
  }
}
