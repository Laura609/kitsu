import 'package:flutter/material.dart';

class RegisterButtonWidget extends StatelessWidget {
  final bool isFormValid;
  final VoidCallback onTap;

  const RegisterButtonWidget({
    super.key,
    required this.isFormValid,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: isFormValid ? onTap : null, // disable tap if form is not valid
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isFormValid
                ? const Color.fromRGBO(2, 217, 173, 1)
                : const Color.fromRGBO(168, 168, 168, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Зарегистрироваться',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
