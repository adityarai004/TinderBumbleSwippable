import 'package:flutter/material.dart';
import 'package:klickrasgn/card_model.dart';
import 'package:klickrasgn/home_provider.dart';
import 'package:klickrasgn/swippable_card.dart';
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
  final List<CardModel> cards = [
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

  void handleSwipe(DragUpdateDetails details) {
    setState(() {
      cardOffset += details.delta;
    });
  }

  void handleSwipeEnd(DragEndDetails details) {
    if (cardOffset.dx > 100 || cardOffset.dx < -100) {
      final isSwipingRight = cardOffset.dx > 0;
      setState(() {
        cardOffset = Offset(isSwipingRight ? 300 : -300, 0); // Animate outwards
      });

      // Wait for the transition to complete before removing the card
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          cards.removeAt(0);
          cardOffset = Offset.zero; // Reset offset for next card
        });
      });
    } else {
      // Reset the card position if the threshold isn't met
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: cards.isNotEmpty
          ? Stack(
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
                    return index == 0
                        ? TweenAnimationBuilder<Offset>(
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
                          )
                        : SwippableCard(
                            card: card,
                            cardColor: null,
                          );
                  })
                  .toList()
                  .reversed
                  .toList(),
            )
          : const Text(
              "No cards left",
              style: TextStyle(fontSize: 24),
            ),
    );
  }
}
