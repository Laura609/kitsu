import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Constants/constant.dart';
import 'package:test1/Pages/Routs/skill_mentor_or_student_page.dart';
import 'package:test1/Widgets/register_button_widget.dart';
import 'package:test1/Widgets/text_input_widgets/age_textfield_widget.dart';
import 'package:test1/Widgets/text_input_widgets/email_textfield_widget.dart';
import 'package:test1/Widgets/text_input_widgets/password_textfield_widget.dart';
import 'package:test1/Widgets/text_input_widgets/role_selection_widget.dart';
import 'package:test1/Widgets/text_widget.dart';
import 'package:test1/Widgets/text_input_widgets/name_textfield_widget.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _roleController = TextEditingController();
  final _firsNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String selectedRole = '';
  bool _isTouched = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    // Подписываемся на изменения в полях
    _roleController.addListener(_checkFormValidity);
    _firsNameController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _ageController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
    _confirmPasswordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _roleController.removeListener(_checkFormValidity);
    _firsNameController.removeListener(_checkFormValidity);
    _emailController.removeListener(_checkFormValidity);
    _ageController.removeListener(_checkFormValidity);
    _passwordController.removeListener(_checkFormValidity);
    _confirmPasswordController.removeListener(_checkFormValidity);
    super.dispose();
  }

  // Проверка на правильность заполнения формы
  void _checkFormValidity() {
    setState(() {
      bool isValidAge = _ageController.text.isNotEmpty &&
          RegExp(r'^[1-9][0-9]?$|^120$').hasMatch(_ageController.text.trim());

      bool isValidPassword = _passwordController.text.trim() ==
          _confirmPasswordController.text.trim();

      bool isValidEmail =
          RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
              .hasMatch(_emailController.text.trim());

      // Убедимся, что все поля заполнены корректно
      _isFormValid = selectedRole.isNotEmpty &&
          _firsNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          isValidEmail &&
          isValidAge &&
          _passwordController.text.isNotEmpty &&
          isValidPassword;
    });
  }

  Future<void> signUp() async {
    setState(() {
      _isTouched = true;
    });

    if (_isFormValid) {
      try {
        // Регистрация пользователя в Firebase
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Сохранение данных в Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_emailController.text.trim())
            .set({
          'email': _emailController.text.trim(),
          'first_name': _firsNameController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()) ?? 0,
          'role': selectedRole,
          'username': _firsNameController.text.trim(),
          'bio': '',
        });

        // После успешной регистрации, перенаправляем на главную страницу
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SkillMentorOrStudentPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Ошибка регистрации. Попробуйте снова позже.';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Этот email уже используется. Попробуйте другой.';
        } else if (e.code == 'weak-password') {
          errorMessage =
              'Пароль слишком слабый. Используйте более сложный пароль.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Некорректный email. Пожалуйста, проверьте формат.';
        }

        // Показываем сообщение об ошибке
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Пожалуйста, заполните все поля правильно.")),
        );
      }
    }
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
                  const TextWidget(
                    textTitle: 'Добро пожаловать!',
                    textTitleColor: Colors.white,
                    textTitleSize: 14,
                  ),
                  const SizedBox(height: 20),
                  RoleSelectionWidget(
                    selectedRole: selectedRole,
                    onRoleSelected: (role) {
                      setState(() {
                        selectedRole = role;
                      });
                      _checkFormValidity();
                    },
                    isTouched: _isTouched,
                  ),
                  const SizedBox(height: 20),
                  NameTextFieldWidget(
                    hintText: 'Имя',
                    controller: _firsNameController,
                    isTouched: _isTouched,
                  ),
                  const SizedBox(height: 20),
                  EmailTextFieldWidget(
                    hintText: 'Email',
                    controller: _emailController,
                    isTouched: _isTouched,
                  ),
                  const SizedBox(height: 10),
                  AgeTextFieldWidget(
                    hintText: 'Возраст',
                    controller: _ageController,
                    isTouched: _isTouched,
                  ),
                  const SizedBox(height: 10),
                  PasswordTextFieldWidget(
                    hintText: 'Пароль',
                    controller: _passwordController,
                    isTouched: _isTouched,
                  ),
                  const SizedBox(height: 20),
                  PasswordTextFieldWidget(
                    hintText: 'Повторите пароль',
                    controller: _confirmPasswordController,
                    confirmPassword: _passwordController.text,
                    isTouched: _isTouched,
                  ),
                  const SizedBox(height: 20),
                  RegisterButtonWidget(
                    isFormValid: _isFormValid,
                    onTap: signUp,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Уже есть аккаунт? ',
                        style: TextStyle(
                          color: Color.fromRGBO(168, 168, 168, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text(
                          'Войти',
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
