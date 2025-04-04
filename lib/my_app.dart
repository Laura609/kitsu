import 'package:flutter/material.dart';
import 'package:test1/router/router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router.config(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(36, 36, 36, 1),
        primaryColor: const Color.fromRGBO(2, 217, 173, 1),
      ),
    );
  }
}
