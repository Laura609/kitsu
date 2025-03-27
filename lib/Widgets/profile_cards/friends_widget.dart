import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/friends_page.dart';
import 'package:test1/Widgets/loading_widget.dart';

class MentorStudentFriendsWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final String email; // email пользователя
  final VoidCallback? onTap; // Делаем callback необязательным

  const MentorStudentFriendsWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.email,
    this.onTap, // Теперь необязательный параметр
  });

  // Метод для получения количества друзей
  Future<int> _getFriendsCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .collection('friends')
          .get();

      return snapshot.size; // Количество документов в коллекции friends
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = screenWidth * 0.3;
    double containerHeight = screenHeight * 0.16;
    double iconSize = screenWidth * 0.1;
    double textSize = screenWidth * 0.05;

    return GestureDetector(
      onTap: onTap ??
          () {
            // Если onTap не передан, используем переход по умолчанию
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendsPage(), // Используем FriendsPage
              ),
            );
          },
      child: FutureBuilder<int>(
        future: _getFriendsCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          int friendsCount =
              snapshot.hasError || !snapshot.hasData ? 0 : snapshot.data!;

          return Container(
            height: containerHeight,
            width: containerWidth,
            margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(47, 47, 47, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Icon(
                  icon,
                  size: iconSize,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  '$friendsCount',
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: textSize * 0.6,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
