import 'package:flutter/material.dart';

class EmailTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isTouched;

  const EmailTextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isTouched,
  });

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email.trim());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.07;

    // Проверка валидности email
    bool isValidEmail = _isValidEmail(controller.text);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Контейнер для ввода email
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
              keyboardType: TextInputType.emailAddress,
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
                  Icons.email,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Проверка корректности email
          if (isTouched && !isValidEmail && controller.text.isNotEmpty)
            const Text(
              'Некорректный email',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
