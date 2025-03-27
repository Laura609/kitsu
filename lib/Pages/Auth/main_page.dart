import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Auth/auth_page.dart';
import 'package:test1/Pages/Routs/mentor_or_student_profile_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MentorOrStudentProfilePage();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
