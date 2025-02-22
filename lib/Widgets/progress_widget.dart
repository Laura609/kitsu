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
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _checkStreak();
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
      setState(() {
        _progress = progress.toDouble();
      });
    }
  }

  // Функция для проверки стрика
  Future<void> _checkStreak() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) return;

    // Получаем данные пользователя
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .get();

    if (userDoc.exists) {
      final lastActiveDate = userDoc.data()?['lastActiveDate']?.toDate();

      if (lastActiveDate != null) {
        final currentDate = DateTime.now();
        final timeDifference = currentDate.difference(lastActiveDate).inHours;

        // Если прошло меньше 24 часов
        if (timeDifference < 24) {
          setState(() {
            _streak =
                userDoc.data()?['streakCount'] ?? 0 + 1; // Увеличиваем стрик
          });
        } else {
          setState(() {
            _streak = 0; // Сбрасываем стрик
          });
        }
      }
    }
  }

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
          Icon(widget.icon, color: Colors.white),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.courseName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_progress.toStringAsFixed(0)}%', // Показываем процент прогресса
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                'Стрик: $_streak', // Показываем текущий стрик
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
