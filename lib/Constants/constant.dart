import 'package:flutter/material.dart';

/// Supabase клиент
const preloader = Center(
  child: CircularProgressIndicator(color: Color.fromRGBO(2, 217, 173, 1)),
);

/// Простой SizedBox для добавления отступов между элементами формы
const formSpacer = SizedBox(width: 16, height: 16);

/// Padding для всех форм
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 20);

/// Сообщение об ошибке, отображаемое пользователю при возникновении непредвиденной ошибки.
const unexpectedErrorMessage = 'Произошла непредвиденная ошибка.';

/// Основная тема для изменения внешнего вида приложения
final appTheme = ThemeData.dark().copyWith(
  primaryColorDark: Colors.grey[900],
  appBarTheme: const AppBarTheme(
    elevation: 0, // Установите elevation в 0
    backgroundColor: Color.fromRGBO(26, 26, 26, 1),
    iconTheme: IconThemeData(color: Color.fromRGBO(168, 168, 168, 1)),
    titleTextStyle: TextStyle(
      color: Color.fromRGBO(168, 168, 168, 1),
      fontSize: 14,
    ),
  ),
  primaryColor: const Color.fromRGBO(2, 217, 173, 1),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color.fromRGBO(2, 217, 173, 1),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(
      color: Color.fromRGBO(2, 217, 173, 1),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color.fromRGBO(2, 217, 173, 1),
        width: 2,
      ),
    ),
  ),
);

/// Сообщения об ошибках Firebase
const firebaseAuthErrorMessages = {
  'user-not-found': 'Пользователь не найден. Проверьте введенные данные.',
  'wrong-password': 'Неверный пароль. Попробуйте еще раз.',
  'email-already-in-use': 'Этот email уже используется. Попробуйте другой.',
  'network-request-failed': 'Ошибка сети. Проверьте подключение.',
};

/// Набор методов расширения для простого отображения snackbar
extension ShowSnackBar on BuildContext {
  /// Отображает базовый snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Отображает красный snackbar, указывающий на ошибку
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }

  /// Отображает сообщение об ошибке Firebase
  void showFirebaseErrorSnackBar({required String errorCode}) {
    final errorMessage =
        firebaseAuthErrorMessages[errorCode] ?? unexpectedErrorMessage;
    showErrorSnackBar(message: errorMessage);
  }
}
