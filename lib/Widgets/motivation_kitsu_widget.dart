import 'package:flutter/material.dart';

class MotivationKitsuWidget extends StatelessWidget {
  final VoidCallback onTap;

  const MotivationKitsuWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(53, 51, 51, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Два текста рядом
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.3, // Межстрочный интервал
                ),
                children: [
                  const TextSpan(
                    text: 'НЕ ПОТЕРЯЙТЕ СВОЮ МОТИВАЦИЮ!\n',
                    style: TextStyle(color: Colors.white),
                  ),
                  const TextSpan(
                    text: 'ТЕБЕ ПОМОЖЕТ НАШ ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'KITSU',
                    style: TextStyle(
                      color: Color.fromRGBO(254, 109, 142, 1),
                      // Можно добавить дополнительные стили для выделенного текста
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 0),
            // Иконка справа
            Image(
              image: AssetImage('assets/rrr.png'),
              width: 55,
              height: 55,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}
