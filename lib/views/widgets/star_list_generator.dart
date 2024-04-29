import 'package:flutter/material.dart';

List<Widget> starListGenerator(int stars, int coloredStars, double size) {
  List<Widget> starList =
      List.filled(stars, Icon(Icons.star_border, size: size));
  starList.fillRange(
      0, coloredStars, Icon(Icons.star, color: Colors.yellow, size: size));
  return starList;
}
