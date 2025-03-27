import 'package:flutter/material.dart';

class PremiumOfferWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String description;
  final String priceText;
  final String imageAsset;

  const PremiumOfferWidget({
    required this.onTap,
    required this.description,
    required this.priceText,
    required this.imageAsset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color.fromRGBO(53, 51, 51, 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column with text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
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

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Price button
                  Container(
                    width: 190,
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
                        priceText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(254, 109, 142, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right image
            Container(
              width: 120,
              height: 120,
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
