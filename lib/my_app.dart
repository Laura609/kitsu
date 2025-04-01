import 'package:flutter/material.dart';
import 'package:test1/Pages/Auth/main_page.dart';
import 'package:test1/Pages/Questions/level.dart';
import 'package:test1/Pages/Questions/mentor_skill.dart';
import 'package:test1/Pages/Questions/student_skill.dart';
import 'package:test1/Pages/chats_page.dart';
import 'package:test1/Pages/friends_page.dart';
import 'package:test1/Pages/home_page.dart';
import 'package:test1/Pages/Profiels/mentor_profile_page.dart';
import 'package:test1/Pages/Routs/mentor_or_student_profile_page.dart';
import 'package:test1/Pages/Profiels/student_profile_page.dart';
import 'package:test1/Pages/training_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        FriendsPage.routeName: (context) => const FriendsPage(),
        ChatsPage.routeName: (context) => ChatsPage(),
        MentorOrStudentProfilePage.routeName: (context) =>
            const MentorOrStudentProfilePage(),
        TrainingPage.routeName: (context) => const TrainingPage(),
        MentorProfilePage.routeName: (context) => const MentorProfilePage(),
        MentorLevelSelectionPage.routeName: (context) =>
            const MentorLevelSelectionPage(),
        MentorSkillSelectionPage.routeName: (context) =>
            const MentorSkillSelectionPage(),
        StudentSkillSelectionPage.routeName: (context) =>
            const StudentSkillSelectionPage(),
        StudentProfilePage.routeName: (context) => const StudentProfilePage(),
      },
    );
  }
}
