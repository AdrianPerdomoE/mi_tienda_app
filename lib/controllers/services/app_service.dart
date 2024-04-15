import 'package:flutter/material.dart';

class AppService {
  String _appName = "Mi Tienda App";
  Color _primaryColor = const Color.fromRGBO(247, 200, 29, 1);
  Color _secondaryColor = const Color.fromRGBO(171, 207, 185, 1);
  Color _accentColor = const Color.fromRGBO(134, 151, 195, 1);
  Color _backgroundColor = const Color.fromRGBO(250, 249, 245, 1);
  Color _textColor = const Color.fromRGBO(13, 12, 8, 1);

  String get appName => _appName;
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get accentColor => _accentColor;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;

  void changeAppName(String name) {
    _appName = name;
  }

  void changeTheme(
    Color primaryColor,
    Color secondaryColor,
    Color accentColor,
    Color backgroundColor,
    Color textColor,
  ) {
    _primaryColor = primaryColor;
    _secondaryColor = secondaryColor;
    _accentColor = accentColor;
    _backgroundColor = backgroundColor;
    _textColor = textColor;
  }
}
