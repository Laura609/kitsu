import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:logger/logger.dart'; // Add the logger import

class UserProfileWidget extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserProfileWidget({required this.user, super.key});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  late Future<bool> isFriendFuture;
  final logger = Logger(); // Instantiate the logger

  @override
  void initState() {
    super.initState();
    isFriendFuture = _checkIfFriend();
  }

  Future<bool> _checkIfFriend() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    try {
      final currentUserFriendsRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .collection('friends')
          .doc(widget.user['email']);

      final docSnapshot = await currentUserFriendsRef.get();
      return docSnapshot.exists;
    } catch (e) {
      logger.e(
          'Error checking if user is a friend: $e'); // Use logger instead of print
      return false;
    }
  }

  Future<void> _updateFriendStatus(bool add) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final currentUserFriendsRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .collection('friends');

      final userFriendsRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.user['email'])
          .collection('friends');

      if (add) {
        await currentUserFriendsRef.doc(widget.user['email']).set({
          'friend_email': widget.user['email'],
          'added_at': Timestamp.now(),
        }, SetOptions(merge: true));

        await userFriendsRef.doc(currentUser.email).set({
          'friend_email': currentUser.email,
          'added_at': Timestamp.now(),
        }, SetOptions(merge: true));

        if (mounted) {
          // Ensure widget is still mounted before showing the snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пользователь добавлен в друзья!')),
          );
        }
      } else {
        await currentUserFriendsRef.doc(widget.user['email']).delete();
        await userFriendsRef.doc(currentUser.email).delete();

        if (mounted) {
          // Ensure widget is still mounted before showing the snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пользователь удален из друзей!')),
          );
        }
      }

      setState(() {
        isFriendFuture = _checkIfFriend();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBarWidget(
        text: widget.user['username'] ?? 'Профиль пользователя',
        isBack: true,
        showSignOutButton: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: FutureBuilder<bool>(
            future: isFriendFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Ошибка: ${snapshot.error}');
              }

              final isFriend = snapshot.data ?? false;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Имя: ${widget.user['username'] ?? 'Не указано'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Био: ${widget.user['bio'] ?? 'Нет информации'}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Роль: ${widget.user['role'] ?? 'Не указана'}',
                    style: TextStyle(
                      color: const Color.fromRGBO(2, 217, 173, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => _updateFriendStatus(!isFriend),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      isFriend ? 'Удалить из друзей' : 'Добавить в друзья',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
