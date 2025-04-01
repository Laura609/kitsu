import 'package:flutter/material.dart';

class PremiumOfferWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String description;
  final String priceText;
  final String imageAsset;

  const PremiumOfferWidget({
    required this.onPressed,
    required this.description,
    required this.priceText,
    required this.imageAsset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 400;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(53, 51, 51, 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left column with text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      children: [
                        const TextSpan(
                          text: 'СТАНЬ ',
                          style: TextStyle(color: Colors.white),
                        ),
                        const TextSpan(
                          text: 'ЛИСОМ - PRO',
                          style: TextStyle(
                              color: Color.fromRGBO(254, 109, 142, 1)),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Price button
                  Container(
                    width: screenWidth * 0.45,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 10 : 12,
                    ),
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
                        priceText,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(254, 109, 142, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right image
            SizedBox(
              width: screenWidth * 0.35,
              height: screenWidth * 0.35,
              child: Image.asset(
                imageAsset,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
