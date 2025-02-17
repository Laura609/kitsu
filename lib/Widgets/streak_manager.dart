import 'package:shared_preferences/shared_preferences.dart';

class StreakManager {
  static const String _lastActiveDateKey = 'lastActiveDate';
  static const String _streakCountKey = 'streakCount';

  // Получить текущий стрик
  static Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  // Обновить стрик
  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActiveDate = prefs.getString(_lastActiveDateKey);
    final currentDate =
        DateTime.now().toIso8601String().split('T')[0]; // Только дата

    if (lastActiveDate == null) {
      // Первый запуск
      await prefs.setString(_lastActiveDateKey, currentDate);
      await prefs.setInt(_streakCountKey, 1);
    } else {
      final lastDate = DateTime.parse(lastActiveDate);
      final currentDateObj = DateTime.parse(currentDate);

      if (currentDateObj.difference(lastDate).inDays == 1) {
        // Пользователь активен два дня подряд
        final currentStreak = prefs.getInt(_streakCountKey) ?? 0;
        await prefs.setInt(_streakCountKey, currentStreak + 1);
      } else if (currentDateObj.difference(lastDate).inDays > 1) {
        // Пропущен день, сброс стрика
        await prefs.setInt(_streakCountKey, 1);
      }

      // Обновляем последнюю активную дату
      await prefs.setString(_lastActiveDateKey, currentDate);
    }
  }

  // Сбросить стрик
  static Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastActiveDateKey);
    await prefs.remove(_streakCountKey);
  }
}
