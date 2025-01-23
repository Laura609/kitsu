import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String textTitle;
  final Color textTitleColor;
  final double textTitleSize;

  const TextWidget({
    super.key,
    required this.textTitle,
    required this.textTitleColor,
    required this.textTitleSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          textTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: textTitleSize,
            color: textTitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
