import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/button_widget.dart';
import 'package:test1/Widgets/text_input_widgets/email_textfield_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final bool _isTouched = false; // Mark as final

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Renamed the function to lowercase camel case
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Ссылка для сброса пароля отправлена!'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Removed print statement
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Сброс пароля'),
      ),
      body: Column(
        children: <Widget>[
          // Текст
          const SizedBox(height: 90),
          const Center(
            child: Text(
              'Напишите свой Email,\nи мы вышлем вам письмо',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Ввод Email
          const SizedBox(height: 30),
          EmailTextFieldWidget(
            hintText: 'Email',
            controller: _emailController,
            isTouched: _isTouched, // Передаем значение isTouched
          ),

          // Кнопка отправки смс
          const SizedBox(height: 30),
          ButtonWidget(
            onPressed: passwordReset, // Function is renamed
            buttonName: 'Сбросить Пароль',
            buttonColor: const Color.fromRGBO(2, 217, 173, 1),
          ),
        ],
      ),
    );
  }
}
