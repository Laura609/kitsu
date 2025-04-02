import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Pages/Course/widgets/training_menu_widget.dart';

@RoutePage()
class CoursePage extends StatelessWidget {
  static const routeName = '/training';

  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        text: 'ДИЗАЙН',
        textColor: Color.fromRGBO(2, 217, 173, 1),
        isBack: true,
        showSignOutButton: false,
      ),
      body: Container(
        color: const Color.fromRGBO(36, 36, 36, 1),
        child: const TrainingMenu(),
      ),
    );
  }
}
