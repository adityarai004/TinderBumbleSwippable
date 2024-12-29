
import 'package:flutter/material.dart';
import 'package:klickrasgn/data/guide_model.dart';
import 'package:lottie/lottie.dart';

class GuideCardItem extends StatelessWidget {
  const GuideCardItem({
    super.key,
    required this.guides,
  });

  final GuideModel guides;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset(
          guides.asset,
          height: 125,
          width: 125,
        ),
        Text(
          guides.title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
