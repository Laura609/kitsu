import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final String courseName;
  final double progress;
  final IconData icon;

  const ProgressWidget({
    super.key,
    required this.courseName,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Получаем ширину экрана и вычисляем 90% от неё
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9;

    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 43, 43, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                courseName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(
            '${progress.toStringAsFixed(0)}%', // Убираем дробную часть
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
