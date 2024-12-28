import 'package:flutter/material.dart';
import 'package:klickrasgn/card_model.dart';
import 'package:lottie/lottie.dart';

class SwippableCard extends StatelessWidget {
  const SwippableCard({
    super.key,
    required this.card,
    required this.cardColor,
    this.swipeProgress,
    this.onTap,
  });

  final CardModel card;
  final Color? cardColor;
  final double? swipeProgress;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                card.imgPath,
                fit: BoxFit.cover,
              ),
            ),

            // Gradient overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),

            // Card details
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Text(
                          '${card.firstName} ${card.lastName}',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        card.age,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    card.intro,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {
                        if (onTap != null) onTap!();
                      },
                      child: const Text(
                        "Reject",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lottie animations
            if (swipeProgress != null && swipeProgress! > 0.1)
              Positioned(
                bottom: 5,
                top: 10,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset("assets/like.json", repeat: true),
                ),
              )
            else if (swipeProgress != null && swipeProgress! < -0.1)
              Positioned(
                right: 5,
                bottom: 10,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset("assets/cross.json", repeat: true),
                ),
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: cardColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
