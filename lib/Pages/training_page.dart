import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/courses/training_menu_widget.dart';

class TrainingPage extends StatelessWidget {
  static const routeName = '/training';

  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        text: 'Курс',
        isBack: true,
        showSignOutButton: true,
      ),
      body: Container(
        color: const Color.fromRGBO(36, 36, 36, 1),
        child: const TrainingMenu(),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
