import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Dialogs/add_chat_dialog.dart';
import 'package:test1/Pages/personal_message_page.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/services/chat/chat_service.dart';

class ChatsPage extends StatelessWidget {
  static const routeName = '/chats';
  final ChatService _chatService = ChatService();

  ChatsPage({super.key});

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
        stream: _chatService.getChats(currentUser.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/chat.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Здесь могла быть\nтвоя история общения',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final chatDoc = snapshot.data!.docs[index];
              final otherUserId = chatDoc.id;
              final chatData = chatDoc.data() as Map<String, dynamic>;
              final lastMessage = chatData['last_message'] ?? 'Нет сообщений';
              final lastMessageTime =
                  chatData['last_message_time'] as Timestamp?;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: const CircleAvatar(
                          child: Icon(Icons.person, color: Colors.white)),
                      title: const Text(
                        'Загрузка...',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        lastMessage,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: lastMessageTime != null
                          ? Text(
                              '${lastMessageTime.toDate().hour}:${lastMessageTime.toDate().minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: Colors.grey),
                            )
                          : null,
                    );
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final userName =
                      userData['username'] ?? otherUserId.split('@')[0];
                  final isOnline = _isUserOnline(userData['lastEntry']);

                  return ListTile(
                    leading: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        if (isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(2, 217, 173, 1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      lastMessage,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: lastMessageTime != null
                        ? Text(
                            '${lastMessageTime.toDate().hour}:${lastMessageTime.toDate().minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: Colors.grey),
                          )
                        : null,
                    onTap: () {
                      AppNavigator.fadePush(
                        context,
                        PersonalMessagePage(
                          currentUserId: currentUser.email!,
                          otherUserId: otherUserId,
                          otherUserEmail: otherUserId,
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
        onPressed: () {
          AppNavigator.fadeDialog(
            context,
            const AddChatDialog(),
          );
        },
        child: const Icon(
          Icons.message,
          color: Color.fromRGBO(43, 43, 43, 1),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  bool _isUserOnline(dynamic lastEntry) {
    if (lastEntry == null) return false;
    if (lastEntry is! Timestamp) return false;

    final difference = DateTime.now().difference(lastEntry.toDate());
    return difference.inMinutes < 5;
  }
}
