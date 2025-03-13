import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    // Обновляем метаданные для обоих пользователей
    await _updateUserChatMetadata(
        senderId, receiverId, message, true); // true - это sender
    await _updateUserChatMetadata(
        receiverId, senderId, message, false); // false - это не sender

    // Сохраняем сообщение в подколлекции messages для sender
    await _firestore
        .collection('Users')
        .doc(senderId)
        .collection('friends')
        .doc(receiverId)
        .collection('messages')
        .add({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Сохраняем сообщение в подколлекции messages для receiver
    await _firestore
        .collection('Users')
        .doc(receiverId)
        .collection('friends')
        .doc(senderId)
        .collection('messages')
        .add({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _updateUserChatMetadata(
    String userId,
    String otherUserId,
    String message,
    bool isSender,
  ) async {
    // Форматируем последнее сообщение для отображения
    final String lastMessageDisplay = isSender ? 'вы: $message' : message;

    // Проверяем существование документа друга
    final friendDoc = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('friends')
        .doc(otherUserId)
        .get();

    if (!friendDoc.exists) {
      // Создаем документ друга, если его нет
      await friendDoc.reference.set({
        'added_at': FieldValue.serverTimestamp(),
      });
    }

    // Обновляем метаданные
    await friendDoc.reference.set({
      'last_message':
          lastMessageDisplay, // Сохраняем отформатированное сообщение
      'last_message_time': FieldValue.serverTimestamp(),
      'last_message_with': otherUserId,
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String user1, String user2) {
    return _firestore
        .collection('Users')
        .doc(user1)
        .collection('friends')
        .doc(user2)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Метод для получения списка друзей с последними сообщениями
  Stream<QuerySnapshot> getFriendsWithLastMessages(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('friends')
        .orderBy('last_message_time', descending: true)
        .snapshots();
  }
}
