import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRepository {
  // Получаем список друзей текущего пользователя
  Stream<List<Map<String, dynamic>>> fetchFriends() {
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

  // Метод для удаления друга
  Future<void> removeFriend(String friendEmail) async {
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
      print('Ошибка при удалении друга: $e');
    }
  }
}
