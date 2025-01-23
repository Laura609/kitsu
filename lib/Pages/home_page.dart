import 'package:flutter/material.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart'; // Убедитесь, что импортировали BottomNavBar

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная страница'),
      ),
      body: const Placeholder(),
      bottomNavigationBar: const BottomNavBar(), // Добавлено сюда
    );
  }
}
