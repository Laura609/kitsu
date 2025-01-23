import 'package:flutter/material.dart';

class AlreadyHaveAccountWidget extends StatelessWidget {
  final VoidCallback onTap;

  const AlreadyHaveAccountWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Уже есть аккаунт? ',
          style: TextStyle(
            color: Color.fromRGBO(168, 168, 168, 1),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Войти',
            style: TextStyle(
              color: Color.fromRGBO(2, 217, 173, 1),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
