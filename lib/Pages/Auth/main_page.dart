import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Routs/mentor_or_student_profile_page.dart';
import 'package:test1/Pages/Screens/onboarding_screen.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MentorOrStudentProfilePage();
          } else {
            return const OnBoardingScreen();
          }
        },
      ),
    );
  }
}
