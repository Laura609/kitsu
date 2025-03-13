import 'package:flutter/material.dart';

class AgeTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isTouched;

  const AgeTextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isTouched,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.07;

    // Проверка валидности возраста (число от 1 до 120)
    bool isValidAge =
        RegExp(r'^[1-9][0-9]?$|^120$').hasMatch(controller.text.trim());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Контейнер для ввода возраста
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(34, 34, 34, 1),
              border: Border.all(
                color: const Color.fromRGBO(168, 168, 168, 1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: const Color.fromRGBO(168, 168, 168, 1),
              ),
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Проверка корректности возраста
          if (isTouched && !isValidAge)
            const Text(
              'Введите корректный возраст (от 1 до 120)',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
