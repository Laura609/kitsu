import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/personal_message_page.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';

class ChatsPage extends StatelessWidget {
  static const routeName = '/chats';
  const ChatsPage({super.key});

  Future<void> _showFriendsDialog(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final friendsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .collection('friends')
        .get();

    if (friendsSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('У вас нет друзей')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите друга'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: friendsSnapshot.docs.length,
            itemBuilder: (context, index) {
              final friendEmail = friendsSnapshot.docs[index].id;
              return ListTile(
                title: Text(friendEmail),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalMessagePage(
                        currentUserId: currentUser.email!,
                        otherUserId: friendEmail,
                        otherUserEmail: friendEmail,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBarWidget(
        text: 'Чаты',
        isBack: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .collection('friends')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Нет активных чатов',
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () => _showFriendsDialog(context),
                    child: const Text(
                      'Начать чат',
                      style: TextStyle(color: Color.fromRGBO(2, 217, 173, 1)),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final friendDoc = snapshot.data!.docs[index];
              final friendEmail = friendDoc.id;
              final lastMessage =
                  friendDoc.data().toString().contains('last_message')
                      ? friendDoc['last_message']
                      : 'Нет сообщений';
              final lastMessageTime =
                  friendDoc.data().toString().contains('last_message_time')
                      ? friendDoc['last_message_time'] as Timestamp?
                      : null;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(friendEmail)
                    .get(),
                builder: (context, userSnapshot) {
                  // Если данные о пользователе не загружены, показываем placeholder
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircleAvatar(
                          child: Icon(Icons.person, color: Colors.white)),
                      title: Text(
                        'Загрузка...',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        lastMessage,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: lastMessageTime != null
                          ? Text(
                              '${lastMessageTime.toDate().hour}:${lastMessageTime.toDate().minute}',
                              style: TextStyle(color: Colors.grey),
                            )
                          : null,
                    );
                  }

                  // Если пользователь не найден, используем email как имя
                  final userName = userSnapshot.hasData &&
                          userSnapshot.data!.exists &&
                          userSnapshot.data!.data() != null
                      ? (userSnapshot.data!.data()
                              as Map<String, dynamic>)['name'] ??
                          friendEmail.split('@')[0]
                      : friendEmail.split('@')[0];

                  return ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person, color: Colors.white)),
                    title: Text(
                      userName,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      lastMessage,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: lastMessageTime != null
                        ? Text(
                            '${lastMessageTime.toDate().hour}:${lastMessageTime.toDate().minute}',
                            style: TextStyle(color: Colors.grey),
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalMessagePage(
                            currentUserId: currentUser.email!,
                            otherUserId: friendEmail,
                            otherUserEmail: friendEmail,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
        onPressed: () => _showFriendsDialog(context),
        child: const Icon(
          Icons.message,
          color: Color.fromRGBO(43, 43, 43, 1),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
