import 'package:flutter/material.dart';

class CustomTheme {
  Color accent;
  Color background;
  Color primary;
  Color secondary;
  Color text;

  CustomTheme({
    required this.accent,
    required this.background,
    required this.primary,
    required this.secondary,
    required this.text,
  });

  factory CustomTheme.fromMap(Map<String, dynamic> map) {
    return CustomTheme(
      accent: Color(int.parse("ff${map['accent']}", radix: 16)),
      background: Color(int.parse("ff${map['background']}", radix: 16)),
      primary: Color(int.parse("ff${map['primary']}", radix: 16)),
      secondary: Color(int.parse("ff${map['secondary']}", radix: 16)),
      text: Color(int.parse("ff${map['text']}", radix: 16)),
    );
  }
  toJson() {
    return {
      'accent': accent.value.toString(),
      'background': background.value.toString(),
      'primary': primary.value.toString(),
      'secondary': secondary.value.toString(),
      'text': text.value.toString(),
    };
  }
}
