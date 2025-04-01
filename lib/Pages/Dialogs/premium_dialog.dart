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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = screenWidth * 0.8;
    final dialogHeight = screenHeight * 0.8;
    final fontSizeMultiplier = screenWidth / 1080;
    const minFontSize = 16.0;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Фоновое размытие
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.01),
              ),
            ),
          ),
          // Основной контент
          Container(
            width: dialogWidth,
            height: dialogHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromRGBO(255, 255, 255, 0.2),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 124, 124, 124).withAlpha(38),
                  const Color.fromARGB(255, 77, 76, 76).withAlpha(128),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.03),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: _scaleFontSize(
                                    24, fontSizeMultiplier, minFontSize),
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Пользователи ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'ЛИСЫ - PRO\n',
                                  style: TextStyle(
                                      color: const Color.fromRGBO(
                                          254, 109, 142, 1)),
                                ),
                                const TextSpan(
                                  text: 'быстрее достигают своих целей',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          _buildFeatureRow(fontSizeMultiplier, 'Весь контент',
                              'Получи доступ ко всем курсам, навыкам в приложении'),
                          SizedBox(height: screenHeight * 0.02),
                          _buildFeatureRow(fontSizeMultiplier, 'Сертификаты',
                              'Заверши весь уровень навыка и получи сертификат'),
                          SizedBox(height: screenHeight * 0.02),
                          _buildFeatureRow(
                              fontSizeMultiplier,
                              'Никакой рекламы',
                              'Убери всю рекламу между обучением, чтобы не отвлекаться'),
                          SizedBox(height: screenHeight * 0.02),
                          _buildFeatureRow(
                              fontSizeMultiplier,
                              'Восстановление стрика',
                              'Не теряй стрик, если пропустишь день обучения'),
                          Spacer(),
                          Center(
                            child: GestureDetector(
                              onTap: onPurchase,
                              child: Container(
                                width: dialogWidth * 0.7,
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.015),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(254, 109, 142, 1),
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'ПОЛУЧИТЬ СЕЙЧАС ЗА 299 ₽',
                                    style: TextStyle(
                                      fontSize: _scaleFontSize(
                                          14, fontSizeMultiplier, 12),
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromRGBO(
                                          254, 109, 142, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                        ],
                      ),
                    ),
                    // Кнопка закрытия
                    Positioned(
                      top: screenWidth * 0.03,
                      right: screenWidth * 0.03,
                      child: GestureDetector(
                        onTap: onClose,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromRGBO(0, 0, 0, 0.3),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: _scaleFontSize(
                                24, fontSizeMultiplier, minFontSize),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _scaleFontSize(double baseSize, double multiplier, double minSize) {
    return (baseSize * multiplier).clamp(minSize, double.infinity);
  }

  Widget _buildFeatureRow(
      double fontSizeMultiplier, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          height: _scaleFontSize(60, fontSizeMultiplier, 40),
          child: Icon(
            Icons.lock_open_rounded,
            color: const Color.fromRGBO(254, 109, 142, 1),
            size: _scaleFontSize(40, fontSizeMultiplier, 24),
            shadows: const [
              Shadow(
                color: Color.fromRGBO(0, 0, 0, 0.4),
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
                  fontSize: _scaleFontSize(18, fontSizeMultiplier, 14),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: _scaleFontSize(5, fontSizeMultiplier, 4)),
              Text(
                description,
                style: TextStyle(
                  fontSize: _scaleFontSize(16, fontSizeMultiplier, 12),
                  color: const Color.fromRGBO(255, 255, 255, 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
