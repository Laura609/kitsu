import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Constants/constant.dart';
import 'package:test1/Pages/Auth/forgot_password_page.dart';
import 'package:test1/Pages/Auth/main_page.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/text_input_widgets/email_textfield_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/text_widget.dart';
import 'package:test1/Widgets/text_input_widgets/password_textfield_widget.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isEmailTouched = false;
  final bool _isPasswordTouched = false;

  Future<void> signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Пожалуйста, заполните все поля")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingWidget(),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop();

      // Плавный переход на главную страницу
      AppNavigator.fadePush(
        context,
        const MainPage(), // Замените на ваш виджет MainScreen
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      String errorMessage = 'Ошибка входа. Попробуйте снова позже.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Пользователь не найден. Проверьте email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Неверный пароль. Попробуйте снова.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Некорректный email. Пожалуйста, проверьте формат.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Произошла ошибка. Попробуйте позже.")),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: formPadding,
            child: Center(
              child: Column(
                children: <Widget>[
                  const Image(
                    image: AssetImage('assets/rrr.png'),
                    width: 150,
                    height: null,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const TextWidget(
                    textTitle: 'Добро пожаловать назад!\nМы скучали',
                    textTitleColor: Colors.white,
                    textTitleSize: 18,
                  ),
                  const SizedBox(height: 60),
                  EmailTextFieldWidget(
                    hintText: 'Email',
                    controller: _emailController,
                    isTouched: _isEmailTouched,
                  ),
                  const SizedBox(height: 20),
                  PasswordTextFieldWidget(
                    hintText: 'Пароль',
                    controller: _passwordController,
                    isTouched: _isPasswordTouched,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => AppNavigator.fadePush(
                            context,
                            const ForgotPasswordPage(),
                          ),
                          child: const TextWidget(
                            textTitle: 'Забыли пароль?',
                            textTitleColor: Colors.white,
                            textTitleSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(2, 217, 173, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Войти',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Нет аккаунта? ',
                        style: TextStyle(
                          color: Color.fromRGBO(168, 168, 168, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: const Text(
                          'Зарегистрироваться',
                          style: TextStyle(
                            color: Color.fromRGBO(2, 217, 173, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
