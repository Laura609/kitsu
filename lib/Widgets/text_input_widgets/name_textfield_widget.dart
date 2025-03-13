import 'package:flutter/material.dart';

class NameTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isTouched;

  const NameTextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isTouched,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.07;

    // Проверка на пустое значение поля
    bool isEmpty = controller.text.isEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Текстовое поле для ввода имени
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
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Адаптивный размер шрифта
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
                  Icons.person, // Иконка для имени
                  size: 20,
                  color: Colors.grey.shade500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          // Если форма была отправлена и поле пустое, показываем ошибку
          if (isTouched && isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Поле не может быть пустым',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
