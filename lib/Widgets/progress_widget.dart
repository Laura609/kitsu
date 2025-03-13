import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressWidget extends StatefulWidget {
  final String courseName;
  final IconData icon;

  const ProgressWidget({
    super.key,
    required this.courseName,
    required this.icon,
  });

  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // Функция для загрузки прогресса
  Future<void> _loadProgress() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) return;

    // Получаем данные пользователя
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .get();

    if (userDoc.exists) {
      // Получаем прогресс из Firestore
      final progress = userDoc.data()?['progress'] ?? 0;
      if (mounted) {
        // Проверяем, что виджет еще монтирован
        setState(() {
          _progress = progress.toDouble();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Получаем ширину экрана и вычисляем 90% от неё
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9;

    // Устанавливаем цвет иконки и текста в зависимости от прогресса
    Color iconColor = _progress == 100
        ? const Color.fromRGBO(2, 217, 173, 1) // Зеленый цвет при 100%
        : Colors.grey; // Серый цвет при прогрессе меньше 100%

    Color textColor = _progress == 100
        ? const Color.fromRGBO(2, 217, 173, 1) // Зеленый цвет при 100%
        : Colors.grey; // Серый цвет при прогрессе меньше 100%

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
          Icon(widget.icon, color: iconColor), // Иконка с условным цветом
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.courseName,
                style: TextStyle(
                    color: textColor, fontSize: 16), // Текст с условным цветом
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_progress.toStringAsFixed(0)}%', // Показываем процент прогресса
                style: TextStyle(
                    color: textColor,
                    fontSize: 16), // Процент с условным цветом
              ),
            ],
          ),
        ],
      ),
    );
  }
}
