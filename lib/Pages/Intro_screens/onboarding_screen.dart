import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test1/Pages/Auth/register_page.dart';
import 'package:test1/Pages/Auth/login_page.dart';
import 'package:test1/Pages/Intro_screens/intro_page_1.dart';
import 'package:test1/Pages/Intro_screens/intro_page_2.dart';
import 'package:test1/Pages/Intro_screens/intro_page_3.dart';
import 'package:test1/Widgets/text_widget.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  bool onLastPage = false;
  int _currentPage = 0;
  bool _isForward = true;

  @override
  void initState() {
    super.initState();
    // Timer logic for automatic page transitions
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isForward) {
        if (_currentPage < 2) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
          _currentPage++;
        } else {
          _isForward = false;
          _pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
          _currentPage--;
        }
      } else {
        if (_currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
          _currentPage--;
        } else {
          _isForward = true;
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
          _currentPage++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView для перехода между экранами
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [IntroPage1(), IntroPage2(), IntroPage3()],
          ),
          // Нижняя панель с индикатором и кнопками
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: const Color.fromRGBO(36, 36, 36, 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const WormEffect(
                      activeDotColor: Color.fromRGBO(2, 217, 173, 1),
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 10.0,
                    ),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(
                            showLoginPage: () {
                              setState(() {
                                // Переключение на страницу авторизации
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(2, 217, 173, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'НАЧАТЬ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(
                            showRegisterPage: () {
                              setState(() {
                                // Переключение на страницу регистрации
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: const TextWidget(
                      textTitle: 'У МЕНЯ УЖЕ ЕСТЬ АККАУНТ',
                      textTitleColor: Colors.white,
                      textTitleSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
