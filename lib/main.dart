import 'package:flutter/material.dart';
import 'package:klickrasgn/data/card_model.dart';
import 'package:klickrasgn/core/app_asset_constants.dart';
import 'package:klickrasgn/core/app_string_constants.dart';
import 'package:klickrasgn/data/guide_model.dart';
import 'package:klickrasgn/presentation/guide_card_item.dart';
import 'package:klickrasgn/presentation/swippable_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klickr Asgn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'GeneralSans',
      ),
      home: const MyHomePage(title: 'Klickr Assignment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SwipeCardExample(),
    );
  }
}

class SwipeCardExample extends StatefulWidget {
  const SwipeCardExample({super.key});

  @override
  State<SwipeCardExample> createState() => _SwipeCardExampleState();
}

class _SwipeCardExampleState extends State<SwipeCardExample> {
  List<GuideModel> guides = [
    const GuideModel(AppAssetConstants.swipeRightLottie,
        AppStringConstants.swipeRightMessage),
    const GuideModel(
        AppAssetConstants.swipeLeftLottie, AppStringConstants.swipeLeftMessage),
    const GuideModel(
        AppAssetConstants.swipeUpLottie, AppStringConstants.swipeUpMessage),
  ];

  List<CardModel> cards = [
    const CardModel(
      AppStringConstants.johnFirstName,
      AppStringConstants.johnLastName,
      AppStringConstants.johnAge,
      AppStringConstants.johnBio,
      AppAssetConstants.img1,
    ),
    const CardModel(
      AppStringConstants.janeFirstName,
      AppStringConstants.janeLastName,
      AppStringConstants.janeAge,
      AppStringConstants.janeBio,
      AppAssetConstants.img8,
    ),
    const CardModel(
      AppStringConstants.emilyFirstName,
      AppStringConstants.emilyLastName,
      AppStringConstants.emilyAge,
      AppStringConstants.emilyBio,
      AppAssetConstants.img7,
    ),
    const CardModel(
      AppStringConstants.michaelFirstName,
      AppStringConstants.michaelLastName,
      AppStringConstants.michaelAge,
      AppStringConstants.michaelBio,
      AppAssetConstants.img3,
    ),
    const CardModel(
      AppStringConstants.sarahFirstName,
      AppStringConstants.sarahLastName,
      AppStringConstants.sarahAge,
      AppStringConstants.sarahBio,
      AppAssetConstants.img4,
    ),
    const CardModel(
      AppStringConstants.davidFirstName,
      AppStringConstants.davidLastName,
      AppStringConstants.davidAge,
      AppStringConstants.davidBio,
      AppAssetConstants.img5,
    ),
    const CardModel(
      AppStringConstants.sophiaFirstName,
      AppStringConstants.sophiaLastName,
      AppStringConstants.sophiaAge,
      AppStringConstants.sophiaBio,
      AppAssetConstants.img7,
    ),
    const CardModel(
      AppStringConstants.jamesFirstName,
      AppStringConstants.jamesLastName,
      AppStringConstants.jamesAge,
      AppStringConstants.jamesBio,
      AppAssetConstants.img6,
    ),
    const CardModel(
      AppStringConstants.oliviaFirstName,
      AppStringConstants.oliviaLastName,
      AppStringConstants.oliviaAge,
      AppStringConstants.oliviaBio,
      AppAssetConstants.img3,
    ),
    const CardModel(
      AppStringConstants.williamFirstName,
      AppStringConstants.williamLastName,
      AppStringConstants.williamAge,
      AppStringConstants.williamBio,
      AppAssetConstants.img1,
    ),
  ];
  Offset cardOffset = Offset.zero;
  double scale = 1;
  Offset guideCardOffset = Offset.zero;

  void handleSwipe(DragUpdateDetails details) {
    setState(() {
      cardOffset += details.delta;
      scale = (1 + (cardOffset.distance / 300)).clamp(1.0, 1.3);
    });
  }

  void handleSwipeEnd(DragEndDetails details) {
    if (cardOffset.dx > 100 || cardOffset.dx < -100) {
      final isSwipingRight = cardOffset.dx > 0;
      setState(() {
        cardOffset =
            Offset(isSwipingRight ? 800 : -600, -500); // Animate outwards
      });

      // Wait for the transition to complete before removing the card
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          final removedCard = cards[0];
          cards.removeAt(0);
          cards.add(removedCard);
          cardOffset = Offset.zero; // Reset offset for next card
        });
      });
    } else if (cardOffset.dy > 100 || cardOffset.dy < -100) {
      final isSwipingUp = cardOffset.dy > 100;
      setState(() {
        cardOffset = Offset(0, isSwipingUp ? 500 : -500); // Animate outwards
      });

      // Reset the card position if the threshold isn't met
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          final removedCard = cards[0];
          cards.removeAt(0);
          cards.add(removedCard);
          cardOffset = Offset.zero;
        });
      });
    } else {
      setState(() {
        cardOffset = Offset.zero;
      });
    }
  }

  void handleSwipeDown() {
    setState(() {
      cardOffset = const Offset(0, 1000); // Animate outwards
    });

    // Wait for the transition to complete before removing the card
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        cards.removeAt(0);
        cardOffset = Offset.zero; // Reset offset for next card
      });
    });
  }

  void handleGuideSwipeEnd(DragEndDetails details) {
    if (guideCardOffset.dx > 100 || guideCardOffset.dx < -100) {
      final isSwipingRight = guideCardOffset.dx > 0;
      setState(() {
        guideCardOffset =
            Offset(isSwipingRight ? 800 : -600, -500); // Animate outwards
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          if ((guides.length == 3 && isSwipingRight) ||
              (guides.length == 2 && !isSwipingRight)) {
            guides.removeAt(0);
          }
          guideCardOffset = Offset.zero;
        });
      });
    } else if (guideCardOffset.dy > 100 || guideCardOffset.dy < -100) {
      final isSwipingUp = guideCardOffset.dy > 100;
      setState(() {
        guideCardOffset =
            Offset(-500, isSwipingUp ? 500 : -500); // Animate outwards
      });

      // Reset the card position if the threshold isn't met
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          if (guides.length == 1) {
            guides.removeAt(0);
          }
          guideCardOffset = Offset.zero;
        });
      });
    } else {
      setState(() {
        guideCardOffset = Offset.zero;
      });
    }
  }

  void handleGuideRightSwipe(DragUpdateDetails details) {
    debugPrint("Handling right swipe for guide");
    setState(() {
      guideCardOffset += details.delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: cards.isNotEmpty
          ? Stack(
              children: [
                Stack(
                  children: cards
                      .asMap()
                      .entries
                      .map((entry) {
                        int index = entry.key;
                        CardModel card = entry.value;
                        double swipeProgress =
                            (cardOffset.dx / 300).clamp(-1.0, 1.0);
                        Color cardColor = Color.lerp(
                          Colors.transparent,
                          Colors.green,
                          swipeProgress,
                        )!;
                        if (swipeProgress > 0) {
                          cardColor = Color.lerp(
                            Colors.transparent,
                            Colors.green.withOpacity(0.7),
                            swipeProgress * 1.05,
                          )!;
                        } else {
                          cardColor = Color.lerp(
                            Colors.transparent,
                            Colors.red.withOpacity(0.5),
                            swipeProgress.abs() * 1.05,
                          )!;
                        }
                        Offset offset = Offset(0, index * 20.0);

                        if (index == 0) {
                          return TweenAnimationBuilder<Offset>(
                            tween: Tween<Offset>(
                              begin: cardOffset,
                              end: cardOffset,
                            ),
                            duration: const Duration(milliseconds: 400),
                            builder: (context, animatedOffset, child) {
                              return Transform.translate(
                                offset: animatedOffset,
                                child: Transform.rotate(
                                  angle: animatedOffset.dx / 225,
                                  child: GestureDetector(
                                    onPanUpdate: handleSwipe,
                                    onPanEnd: handleSwipeEnd,
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: SwippableCard(
                              card: card,
                              cardColor: cardColor,
                              swipeProgress: swipeProgress,
                              onTap: handleSwipeDown,
                            ),
                          );
                        } else if (index == 1 || index == 2) {
                          double baseRotation = (index == 1) ? 0.1 : -0.1;
                          double rotationNormalizationFactor =
                              (1 - (cardOffset.dx.abs() / 300)).clamp(0, 1);
                          double adjustedRotation =
                              baseRotation * rotationNormalizationFactor;

                          double baseScale = 1.0 - (index * 0.1);
                          double adjustedScale =
                              baseScale + ((scale - 1.0) / 2);
                          return bottomCards(
                            baseScale,
                            adjustedScale,
                            offset,
                            adjustedRotation,
                            card,
                          );
                        }
                        return Transform.scale(
                          scale: 0,
                          child: SwippableCard(
                            card: card,
                            cardColor: null,
                          ),
                        );
                      })
                      .toList()
                      .reversed
                      .toList(),
                ),
                if (guides.isNotEmpty) Positioned.fill(child: _guideCards())
              ],
            )
          : const Text(
              AppStringConstants.noCardLeft,
              style: TextStyle(fontSize: 24),
            ),
    );
  }

  Widget _guideCards() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.5)),
        ),
        Positioned.fill(
          child: GestureDetector(
            onPanUpdate: handleGuideRightSwipe,
            onPanEnd: handleGuideSwipeEnd,
            child: TweenAnimationBuilder<Offset>(
              tween: Tween(begin: guideCardOffset, end: guideCardOffset),
              duration: const Duration(milliseconds: 300),
              builder: (context, tweenOffset, child) {
                return Transform.translate(
                  offset: guideCardOffset,
                  child: Transform.rotate(
                    angle: guideCardOffset.dx / 225,
                    child: Container(
                      color: Colors.transparent,
                      child: GuideCardItem(guides: guides[0]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomCards(double baseScale, double adjustedScale, Offset offset,
      double adjustedRotation, CardModel card) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: baseScale, end: adjustedScale),
      duration: const Duration(milliseconds: 400),
      builder: (context, animatedScale, child) {
        return Transform.translate(
          offset: offset,
          child: Transform.scale(
            scale: animatedScale,
            child: Transform.rotate(
              angle: adjustedRotation,
              child: child,
            ),
          ),
        );
      },
      child: SwippableCard(
        card: card,
        cardColor: null,
      ),
    );
  }
}
