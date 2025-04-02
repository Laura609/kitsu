import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/router/router.gr.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;
  final String text;
  final bool showSignOutButton;
  final Color backgroundColor;
  final Color textColor;

  const AppBarWidget({
    super.key,
    required this.text,
    required this.isBack,
    this.showSignOutButton = false,
    this.backgroundColor = const Color.fromRGBO(43, 43, 43, 1),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: isBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.router.pop(),
            )
          : null,
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      actions: showSignOutButton
          ? [
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () => _signOut(context),
              ),
            ]
          : [],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    context.router.replace(const AuthRoute());
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
