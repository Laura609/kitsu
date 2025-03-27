import 'dart:ui';

import 'package:flutter/material.dart';

class PremiumDialog extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onPurchase;

  const PremiumDialog({
    required this.onClose,
    required this.onPurchase,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Фоновое размытие
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.01),
              ),
            ),
          ),
          // Основной контент с эффектом матового стекла
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              // Эффект матового стекла
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 124, 124, 124).withOpacity(0.15),
                  const Color.fromARGB(255, 77, 76, 76).withOpacity(0.5),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 70),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(
                              text: 'Пользователи ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'ЛИСЫ - PRO\n',
                              style: TextStyle(
                                  color: Color.fromRGBO(254, 109, 142, 1)),
                            ),
                            TextSpan(
                              text: 'быстрее достигают своих целей',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildFeatureRow('Весь контент',
                          'Получи доступ ко всем курсам, навыкам в приложении'),
                      SizedBox(height: 15),
                      _buildFeatureRow('Сертификаты',
                          'Заверши весь уровень навыка и получи сертификат'),
                      SizedBox(height: 15),
                      _buildFeatureRow('Никакой рекламы',
                          'Убери всю рекламу между обучением, чтобы не отвлекаться'),
                      SizedBox(height: 15),
                      _buildFeatureRow('Восстановление стрика',
                          'Не теряй стрик, если пропустишь день обучения'),
                      Spacer(),
                      Center(
                        child: GestureDetector(
                          onTap: onPurchase,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromRGBO(254, 109, 142, 1),
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'ПОЛУЧИТЬ СЕЙЧАС ЗА 299 ₽',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(254, 109, 142, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Кнопка закрытия поверх всего
          Positioned(
            top: 40,
            right: 40,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String title, String description) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            height: 60,
            child: Icon(
              Icons.lock_open_rounded,
              color: Color.fromRGBO(254, 109, 142, 1),
              size: 40,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
