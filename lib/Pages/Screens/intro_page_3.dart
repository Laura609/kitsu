import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/text_widget.dart';

@RoutePage()
class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF02D9AD),
              const Color(0xFF00C4A1),
              const Color(0xFF00B0A0),
              const Color(0xFF0098A6),
              const Color(0xFF0075A8),
            ],
            stops: [0.0, 0.3, 0.6, 0.8, 1.0],
            transform: const GradientRotation(0.8),
          ),
        ),
        child: const Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              Image(
                image: AssetImage('assets/splash3.png'),
                width: 400,
                height: 400,
              ),
              TextWidget(
                textTitle: 'Раскрой свой потенциал',
                textTitleColor: Colors.white,
                textTitleSize: 28,
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Ментор поможет тебе достичь большего, чем ты можешь представить',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
