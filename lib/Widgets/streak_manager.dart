import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakManager {
  static const String _streakCountKey =
      'streakCount'; // Используем только SharedPreferences для стрика.
  static const String _lastActiveDateKey =
      'lastActiveDate'; // Для хранения последней активности в SharedPreferences

  // Получить текущий стрик
  static Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  // Обновить стрик пользователя в Firestore
  static Future<void> updateStreak(String email) async {
    final userDoc = await _getUserDoc(email);
    if (userDoc == null || !userDoc.exists) return;

    final lastActiveDate =
        (userDoc.data() as Map<String, dynamic>)['lastActiveDate'];
    final currentDate = DateTime.now()
        .toIso8601String()
        .split('T')[0]; // только дата без времени

    // Если нет даты последней активности
    if (lastActiveDate == null) {
      await _updateFirestoreStreak(email, currentDate, 1);
    } else {
      final lastDate = DateTime.parse(lastActiveDate)
          .toIso8601String()
          .split('T')[0]; // только дата без времени

      // Проверяем разницу в днях
      final lastDateObj = DateTime.parse(lastDate);
      final currentDateObj = DateTime.parse(currentDate);

      if (currentDateObj.difference(lastDateObj).inDays == 1) {
        // Стрик продолжается, увеличиваем стрик на 1
        final currentStreak =
            (userDoc.data() as Map<String, dynamic>)['streakCount'] ?? 0;
        await _updateFirestoreStreak(email, currentDate, currentStreak + 1);
      } else if (currentDateObj.difference(lastDateObj).inDays > 1) {
        // Пропущен день — сбрасываем стрик на 1
        await _updateFirestoreStreak(email, currentDate, 1);
      }
    }
  }

  // Обновление данных стрика в Firestore
  static Future<void> _updateFirestoreStreak(
      String email, String currentDate, int streakCount) async {
    await FirebaseFirestore.instance.collection('Users').doc(email).update({
      'streakCount': streakCount,
      'lastActiveDate': currentDate,
    });
  }

  // Получить документ пользователя из Firestore
  static Future<DocumentSnapshot?> _getUserDoc(String email) async {
    return FirebaseFirestore.instance.collection('Users').doc(email).get();
  }

  // Обновить стрик в SharedPreferences
  static Future<void> updateStreakInPrefs(int streakCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakCountKey, streakCount);
  }

  // Сбросить стрик в SharedPreferences
  static Future<void> resetStreakInPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_streakCountKey);
  }
}
