import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/friend_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/preview_profile/user_profile_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';

class FriendsPage extends StatelessWidget {
  static const routeName = '/friends';
  final logger = Logger();
  FriendsPage({super.key});

  // Получаем список друзей текущего пользователя
  Stream<List<Map<String, dynamic>>> _fetchFriends() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .collection('friends')
        .snapshots()
        .asyncMap((querySnapshot) async {
      final friends = <Map<String, dynamic>>[];
      for (final doc in querySnapshot.docs) {
        final friendEmail = doc.id;
        final friendDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(friendEmail)
            .get();
        if (friendDoc.exists) {
          friends.add(friendDoc.data()!);
        }
      }
      return friends;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBarWidget(
        text: 'Друзья',
        isBack: false,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchFriends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final friends = snapshot.data ?? [];
          if (friends.isEmpty) {
            return const Center(
              child: Text(
                'Нет друзей',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return FriendWidget(
                friend: friend,
                onRemove: () async {
                  await _removeFriend(friend['email']);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileWidget(user: friend),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

// Метод для удаления друга
Future<void> _removeFriend(String friendEmail) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  try {
    // Удаляем друга из списка текущего пользователя
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .collection('friends')
        .doc(friendEmail)
        .delete();

    // Удаляем текущего пользователя из списка друга
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(friendEmail)
        .collection('friends')
        .doc(currentUser.email)
        .delete();
  } catch (e) {
    log('Ошибка при удалении друга: $e');
  }
}
