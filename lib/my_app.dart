import 'package:flutter/material.dart';
import 'package:test1/Pages/Auth/main_page.dart';
import 'package:test1/Pages/home_page.dart';
import 'package:test1/Pages/mentor_profile_page.dart';
import 'package:test1/Pages/mentor_or_student_profile_page.dart';
import 'package:test1/Pages/student_profile_page.dart';
import 'package:test1/Pages/training_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        TrainingPage.routeName: (context) => const TrainingPage(),
        MentorPage.routeName: (context) => const MentorPage(),
        StudentPage.routeName: (context) => const StudentPage(),
        MentorOrStudentPofilePage.routeName: (context) =>
            const MentorOrStudentPofilePage(),
      },
    );
  }
}
