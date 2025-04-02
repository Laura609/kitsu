import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Chat/personal_message_page.dart';
import 'package:test1/Pages/Chat/services/chat_service.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';

class ChatRepository {
  final String _currentUserEmail;

  ChatRepository(this._currentUserEmail);

  Stream<QuerySnapshot> getChatsStream() {
    final chatService = ChatService();
    return chatService.getChats(_currentUserEmail);
  }

  Widget buildChatItem(DocumentSnapshot chatDoc, BuildContext context) {
    final otherUserId = chatDoc.id;
    final chatData = chatDoc.data() as Map<String, dynamic>;
    final lastMessage = chatData['last_message'] ?? 'Нет сообщений';
    final lastMessageTime = chatData['last_message_time'] as Timestamp?;

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('Users').doc(otherUserId).get(),
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

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final userName =
            (userData['first_name'] ?? userData['username'] ?? otherUserId)
                .toString();

        return ListTile(
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                child: Icon(Icons.person, color: Colors.white),
              ),
              if (userData['status'] == 'online')
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(2, 217, 173, 1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
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
                currentUserId: _currentUserEmail,
                otherUserId: otherUserId,
                otherUserEmail: otherUserId,
              ),
            );
          },
        );
      },
    );
  }
}
