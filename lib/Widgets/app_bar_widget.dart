import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Auth/auth_page.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;
  final String text;
  final bool showSignOutButton; // Новый параметр для кнопки выхода

  const AppBarWidget({
    super.key,
    required this.text,
    required this.isBack,
    this.showSignOutButton = false, // По умолчанию кнопка не показывается
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          const Color.fromARGB(255, 27, 27, 27), // Background color
      leading: isBack
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                // Handle back action
                Navigator.pop(context);
              },
            )
          : null, // No leading icon if isBack is false
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true, // Ensures that the text is centered
      actions: showSignOutButton
          ? [
              IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Handle sign-out action
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthPage(),
                    ),
                  );
                },
              ),
            ]
          : [], // Если кнопка не должна отображаться, то список пуст
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Default AppBar height
}
