import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:test1/Pages/Chat/services/chat_service.dart';

class PersonalMessagerepository {
  final String _currentUserId;
  final String _otherUserId;

  PersonalMessagerepository(this._currentUserId, this._otherUserId);

  Stream<QuerySnapshot> getMessagesStream() {
    final chatService = ChatService();
    return chatService.getMessages(_currentUserId, _otherUserId);
  }

  Future<void> sendMessage(String message) async {
    final chatService = ChatService();
    try {
      await chatService.sendMessage(
        senderId: _currentUserId,
        receiverId: _otherUserId,
        message: message,
      );
    } catch (e) {
      debugPrint('Ошибка при отправке сообщения: $e');
    }
  }

  Future<Map<String, dynamic>> loadOtherUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_otherUserId)
        .get();
    return userDoc.data() ?? {};
  }

  String formatLastEntry(dynamic lastEntry) {
    if (lastEntry == null) return 'Недавно';
    if (lastEntry is! Timestamp) return 'Недавно';
    final date = lastEntry.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 5) return 'В сети';
    if (difference.inMinutes < 1) return 'Только что';
    if (difference.inHours < 1) return '${difference.inMinutes} мин назад';
    if (difference.inDays < 1) return '${difference.inHours} ч назад';
    if (difference.inDays < 7) return '${difference.inDays} дн назад';
    return '${date.day}.${date.month}.${date.year}';
  }
}
