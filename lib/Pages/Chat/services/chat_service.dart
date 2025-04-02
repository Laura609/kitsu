import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    // Сохраняем сообщение для отправителя
    await _saveMessage(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      isSent: true,
    );

    // Сохраняем сообщение для получателя
    await _saveMessage(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      isSent: false,
    );

    // Обновляем метаданные чатов
    await _updateChatMetadata(senderId, receiverId, message, true);
    await _updateChatMetadata(receiverId, senderId, message, false);
  }

  Future<void> _saveMessage({
    required String senderId,
    required String receiverId,
    required String message,
    required bool isSent,
  }) async {
    // Сохраняем сообщение в подколлекции messages
    await _firestore
        .collection('Users')
        .doc(isSent ? senderId : receiverId)
        .collection('messages')
        .doc(isSent ? receiverId : senderId)
        .collection('conversation')
        .add({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'is_sent': isSent,
    });
  }

  Future<void> _updateChatMetadata(
    String userId,
    String otherUserId,
    String message,
    bool isSender,
  ) async {
    final chatDocRef = _firestore
        .collection('Users')
        .doc(userId)
        .collection('chats')
        .doc(otherUserId);

    await chatDocRef.set({
      'last_message': isSender ? 'вы: $message' : message,
      'last_message_time': FieldValue.serverTimestamp(),
      'last_message_with': otherUserId,
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(
      String currentUserEmail, String otherUserEmail) {
    return _firestore
        .collection('Users')
        .doc(currentUserEmail)
        .collection('messages')
        .doc(otherUserEmail)
        .collection('conversation')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getChats(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('chats')
        .orderBy('last_message_time', descending: true)
        .snapshots();
  }
}
