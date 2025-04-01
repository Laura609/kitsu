import 'package:flutter/material.dart';

class MotivationKitsuWidget extends StatelessWidget {
  final VoidCallback onTap;

  const MotivationKitsuWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 400;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.09, // 8% высоты экрана
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.04,
        ),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(53, 51, 51, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Текстовая часть
            Flexible(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 13,
                    fontWeight: FontWeight.bold,
                    height: 1.7,
                  ),
                  children: [
                    const TextSpan(
                      text: 'НЕ ПОТЕРЯЙ СВОЮ МОТИВАЦИЮ!\n',
                      style: TextStyle(color: Colors.white),
                    ),
                    const TextSpan(
                      text: 'ТЕБЕ ПОМОЖЕТ НАШ ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'KITSU',
                      style: TextStyle(
                        color: const Color.fromRGBO(254, 109, 142, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Иконка справа
            Image.asset(
              'assets/rrr.png',
              width: screenWidth * 0.15,
              height: screenWidth * 0.15,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}
