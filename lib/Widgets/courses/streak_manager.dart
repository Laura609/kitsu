// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StreakManager {
//   static const String _streakCountKey =
//       'streakCount'; // Для стрика в SharedPreferences.
//   static const String _lastActiveDateKey =
//       'lastActiveDate'; // Для хранения последней активности.

//   // Получить текущий стрик из SharedPreferences
//   static Future<int> getCurrentStreak() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(_streakCountKey) ?? 0; // Если нет данных, вернется 0
//   }

//   // Обновить стрик пользователя в Firestore
//   static Future<void> updateStreak(String email) async {
//     final userDoc = await _getUserDoc(email);
//     if (userDoc == null || !userDoc.exists) {
//       log("User document not found.");
//       return;
//     }

//     final lastActiveDate =
//         (userDoc.data() as Map<String, dynamic>)['lastActiveDate'];
//     final currentDate = DateTime.now()
//         .toIso8601String()
//         .split('T')[0]; // Только дата без времени

//     log("Current date: $currentDate");
//     log("Last active date: $lastActiveDate");

//     // Если нет даты последней активности
//     if (lastActiveDate == null) {
//       await _updateFirestoreStreak(email, currentDate, 1);
//     } else {
//       final lastDate = DateTime.parse(lastActiveDate)
//           .toIso8601String()
//           .split('T')[0]; // Только дата без времени

//       // Проверяем разницу в днях
//       final lastDateObj = DateTime.parse(lastDate);
//       final currentDateObj = DateTime.parse(currentDate);

//       // Если текущая дата на день больше последней активности, продолжаем стрик
//       if (currentDateObj.difference(lastDateObj).inDays == 1) {
//         final currentStreak =
//             (userDoc.data() as Map<String, dynamic>)['streakCount'] ?? 0;
//         await _updateFirestoreStreak(email, currentDate, currentStreak + 1);
//       } else if (currentDateObj.difference(lastDateObj).inDays > 1) {
//         // Если пропущен день — сбрасываем стрик на 1
//         await _updateFirestoreStreak(email, currentDate, 1);
//       } else {
//         log("Streak not updated, no need.");
//       }
//     }
//   }

//   // Обновление стрика в Firestore
//   static Future<void> _updateFirestoreStreak(
//       String email, String currentDate, int streakCount) async {
//     try {
//       await FirebaseFirestore.instance.collection('Users').doc(email).update({
//         'streakCount': streakCount,
//         'lastActiveDate': currentDate,
//       });
//       log("Firestore updated: Streak $streakCount, Last Active Date $currentDate");

//       // Сохраняем стрик в SharedPreferences
//       await updateStreakInPrefs(streakCount);
//       await updateLastActiveDateInPrefs(currentDate);
//     } catch (e) {
//       log("Error updating Firestore: $e");
//     }
//   }

//   // Обновление стрика в SharedPreferences
//   static Future<void> updateStreakInPrefs(int streakCount) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(_streakCountKey, streakCount);
//     log("Streak updated in SharedPreferences: $streakCount");
//   }

//   // Обновление даты последней активности в SharedPreferences
//   static Future<void> updateLastActiveDateInPrefs(String currentDate) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_lastActiveDateKey, currentDate);
//     log("Last active date updated in SharedPreferences: $currentDate");
//   }

//   // Получить документ пользователя из Firestore
//   static Future<DocumentSnapshot?> _getUserDoc(String email) async {
//     try {
//       return FirebaseFirestore.instance.collection('Users').doc(email).get();
//     } catch (e) {
//       log("Error fetching user document: $e");
//       return null;
//     }
//   }

//   // Сбросить стрик в SharedPreferences
//   static Future<void> resetStreakInPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_streakCountKey);
//     log("Streak reset in SharedPreferences.");
//   }
// }
