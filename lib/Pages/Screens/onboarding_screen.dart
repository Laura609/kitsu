import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test1/Pages/Screens/intro_page_1.dart';
import 'package:test1/Pages/Screens/intro_page_2.dart';
import 'package:test1/Pages/Screens/intro_page_3.dart';
import 'package:test1/Widgets/text_widget.dart';
import 'package:test1/router/router.gr.dart';

@RoutePage()
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPageTransition();
    });
  }

  void _startAutoPageTransition() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) return;

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
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.transparent,
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
                  // Кнопка "НАЧАТЬ" - переход на страницу регистрации
                  GestureDetector(
                    onTap: () {
                      context.router.replace(const AuthRoute());
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
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Кнопка "У МЕНЯ УЖЕ ЕСТЬ АККАУНТ" - переход на страницу входа
                  GestureDetector(
                    onTap: () {
                      context.router.replace(const AuthRoute());
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
