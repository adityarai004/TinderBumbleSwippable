import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  List<Color> list = List.from(
      [Colors.amber, Colors.blue, Colors.red, Colors.indigo, Colors.green]);
}
