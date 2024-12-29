import 'package:flutter/material.dart';
import 'package:klickrasgn/card_model.dart';
import 'package:klickrasgn/guide_model.dart';
import 'package:klickrasgn/home_provider.dart';
import 'package:klickrasgn/swippable_card.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'GeneralSans'),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => HomeProvider(),
          ),
        ],
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
    return Consumer<HomeProvider>(
      builder: (context, homeNotifier, child) {
        return const Scaffold(
          body: SwipeCardExample(),
        );
      },
    );
  }
}

class SwipeCardExample extends StatefulWidget {
  const SwipeCardExample({super.key});

  @override
  _SwipeCardExampleState createState() => _SwipeCardExampleState();
}

class _SwipeCardExampleState extends State<SwipeCardExample> {
  final List<GuideModel> guideCard = [
    const GuideModel("assets/lottie/swiperight.json",
        "Swipe right to match with a person :)"),
    const GuideModel("assets/lottie/swipeleft.json", "Swipe left to pass -_-"),
    const GuideModel("assets/lottie/swipeup.json",
        "Swipe up or down to let us know you don't like the recommendation :\\"),
  ];
  List<CardModel> cards = [
    const CardModel("John", "Doe", "25", "Loves hiking and outdoor adventures.",
        "assets/img1.jpg"),
    const CardModel("Jane", "Smith", "28", "Passionate about photography.",
        "assets/img8.jpg"),
    const CardModel(
        "Emily",
        "Johnson",
        "22",
        "Aspiring chef who loves to experimentAspiring chef who loves to experimentAspiring chef who loves to experimentAspiring chef who loves to experimentAspiring chef who loves to experimentAspiring chef who loves to experimentAspiring chef who loves to experimentAspiring chef who loves to experiment.",
        "assets/img2.jpg"),
    const CardModel("Michael", "Brown", "30",
        "Tech enthusiast and software developer.", "assets/img3.jpg"),
    const CardModel("Sarah", "Davis", "27",
        "Yoga practitioner and fitness coach.", "assets/img4.jpg"),
    const CardModel("David", "Wilson", "24",
        "Freelance artist and mural designer.", "assets/img5.jpg"),
    const CardModel("Sophia", "Martinez", "29", "Bookworm and coffee lover.",
        "assets/img7.jpg"),
    const CardModel("James", "Garcia", "26", "Traveler exploring new cultures.",
        "assets/img6.jpg"),
    const CardModel("Olivia", "Clark", "23",
        "Animal rights activist and blogger.", "assets/img3.jpg"),
    const CardModel("William", "Lopez", "31",
        "Music producer with a love for jazz.", "assets/img1.jpg"),
  ];

  int currentIndex = 0;
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
          if ((guideCard.length == 3 && isSwipingRight) ||
              (guideCard.length == 2 && !isSwipingRight)) {
            guideCard.removeAt(0);
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
          if (guideCard.length == 1) {
            guideCard.removeAt(0);
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
                            Colors.green.withOpacity(0.5),
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
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                                begin: baseScale, end: adjustedScale),
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
                if (guideCard.isNotEmpty) ...[
                  Positioned.fill(
                      child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.5),
                  )),
                  Positioned.fill(
                    child: GestureDetector(
                      onPanUpdate: handleGuideRightSwipe,
                      onPanEnd: handleGuideSwipeEnd,
                      child: TweenAnimationBuilder<Offset>(
                        tween:
                            Tween(begin: guideCardOffset, end: guideCardOffset),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, tweenOffset, child) {
                          return Transform.translate(
                            offset: guideCardOffset,
                            child: Transform.rotate(
                              angle: guideCardOffset.dx / 225,
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LottieBuilder.asset(
                                      guideCard[0].asset,
                                      height: 125,
                                      width: 125,
                                    ),
                                    Text(
                                      guideCard[0].title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ]
              ],
            )
          : const Text(
              "No cards left",
              style: TextStyle(fontSize: 24),
            ),
    );
  }
}
