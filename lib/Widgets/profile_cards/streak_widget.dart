import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/profile_cards/profile_card.dart';
import 'package:test1/Widgets/shimer_profile_widget.dart';

class StreakWidget extends StatelessWidget {
  final String text;
  final String email;

  const StreakWidget({
    super.key,
    required this.text,
    required this.email,
  });

  Future<int> _getStreakCount() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();
      if (userDoc.exists) {
        return (userDoc.data() as Map<String, dynamic>)['streakCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('Ошибка при получении стрика: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.3;
    final containerHeight = size.height * 0.16;

    return FutureBuilder<int>(
      future: _getStreakCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerCard(width: containerWidth, height: containerHeight);
        }

        final streakCount = snapshot.data ?? 0;
        return ProfileCard(
          icon: Icons.local_fire_department_rounded,
          title: '$streakCount',
          subtitle: text,
          iconColor: streakCount > 0
              ? const Color.fromRGBO(2, 217, 173, 1)
              : Colors.white,
          containerWidth: containerWidth,
          containerHeight: containerHeight,
        );
      },
    );
  }
}
