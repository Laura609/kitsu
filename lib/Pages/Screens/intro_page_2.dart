import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/text_widget.dart';

@RoutePage()
class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Автоматическая адаптация при открытии клавиатуры
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF02D9AD), // Яркий зеленый (0.0)
              const Color(0xFF00C192), // Насыщенный зеленый (0.3)
              const Color(0xFF008F7A), // Темный зеленый (0.6)
              const Color(0xFF005A4D), // Очень темный зеленый (0.8)
              Color.fromRGBO(36, 36, 36, 1), // Конечный темно-серый (1.0)
            ],
            stops: [0.0, 0.3, 0.6, 0.8, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          // Обертываем содержимое в SingleChildScrollView
          child: SizedBox(
            height:
                screenHeight, // Устанавливаем высоту контейнера равной высоте экрана
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Верхний отступ для поднятия содержимого
                const Spacer(flex: 1), // Добавляем гибкий отступ сверху

                // Динамическое масштабирование изображения
                Image(
                  image: const AssetImage('assets/splash3.png'),
                  width: screenWidth * 0.7, // Увеличиваем ширину изображения
                  height: screenWidth * 0.7, // Увеличиваем высоту изображения
                ),
                const SizedBox(height: 20),
                // Текст заголовка
                TextWidget(
                  textTitle: 'Прокачай свои навыки',
                  textTitleColor: Colors.white,
                  textTitleSize:
                      screenWidth > 600 ? 32 : 28, // Адаптивный размер текста
                ),
                const SizedBox(height: 10),
                // Описание
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Общайся с ментором, получай обратную связь и совершенствуй навыки',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth > 600
                          ? 18
                          : 16, // Адаптивный размер текста
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // Нижний отступ для балансировки
                const Spacer(flex: 2), // Добавляем больший гибкий отступ снизу
              ],
            ),
          ),
        ),
      ),
    );
  }
}
