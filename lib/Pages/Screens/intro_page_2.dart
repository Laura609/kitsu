import 'package:flutter/material.dart';
import 'package:test1/Widgets/text_widget.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(36, 36, 36, 1),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150), // Отступ сверху
            Image(image: AssetImage('assets/splash2.png')),
            SizedBox(height: 30), // Отступ между изображением и текстом
            TextWidget(
              textTitle: 'Страница 2',
              textTitleColor: Colors.white,
              textTitleSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
