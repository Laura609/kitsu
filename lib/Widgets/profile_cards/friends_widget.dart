import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/friends_page.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/profile_cards/profile_card.dart';
import 'package:test1/Widgets/shimer_profile_widget.dart';

class MentorStudentFriendsWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final String email;
  final VoidCallback? onTap;

  const MentorStudentFriendsWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.email,
    this.onTap,
  });

  Future<int> _getFriendsCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .collection('friends')
          .get();
      return snapshot.size;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.3;
    final containerHeight = size.height * 0.16;

    return GestureDetector(
      onTap: onTap ??
          () => AppNavigator.fadePush(
                context,
                FriendsPage(),
              ),
      child: FutureBuilder<int>(
        future: _getFriendsCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerCard(width: containerWidth, height: containerHeight);
          }

          return ProfileCard(
            icon: icon,
            title: '${snapshot.data ?? 0}',
            subtitle: text,
            containerWidth: containerWidth,
            containerHeight: containerHeight,
          );
        },
      ),
    );
  }
}
