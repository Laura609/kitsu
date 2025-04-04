import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Auth/login_page.dart';
import 'package:test1/Pages/Auth/register_page.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreens() => setState(() => showLoginPage = !showLoginPage);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            final curvedAnimation =
                CurvedAnimation(parent: animation, curve: Curves.bounceInOut);
            return FadeTransition(
              opacity:
                  Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0)
                    .animate(curvedAnimation),
                child: child,
              ),
            );
          },
          child: showLoginPage
              ? LoginPage(
                  key: const ValueKey('LoginPage'),
                  showRegisterPage: toggleScreens,
                )
              : RegisterPage(
                  key: const ValueKey('RegisterPage'),
                  showLoginPage: toggleScreens,
                ),
        ),
      ),
    );
  }
}
