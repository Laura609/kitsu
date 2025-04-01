import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final double containerWidth;
  final double containerHeight;
  final Widget? shimmer;

  const ProfileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = Colors.white,
    required this.containerWidth,
    required this.containerHeight,
    this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(47, 47, 47, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Иконка
          Icon(
            icon,
            size: containerWidth *
                0.3, // Размер иконки относительно ширины контейнера
            color: iconColor,
          ),
          const SizedBox(height: 10),
          // Основной текст (например, количество друзей или стрик)
          Text(
            title,
            style: TextStyle(
              fontSize:
                  containerWidth * 0.12, // Размер текста относительно ширины
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          // Подзаголовок (например, "Друзья" или "Стрик")
          Text(
            subtitle,
            style: TextStyle(
              fontSize:
                  containerWidth * 0.10, // Размер текста относительно ширины
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
