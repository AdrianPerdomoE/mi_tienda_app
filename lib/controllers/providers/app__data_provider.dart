import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/custom_theme.dart';

class AppDataProvider extends ChangeNotifier {
  final FirebaseDatabase _realTimeDb = FirebaseDatabase.instance;
  List<CustomTheme> _themes = [];
  String _appName = "Tienda App"; //nombre por defecto
  Color _primaryColor =
      const Color.fromRGBO(247, 200, 29, 1); //colores por defecto
  Color _secondaryColor =
      const Color.fromRGBO(171, 207, 185, 1); //colores por defecto
  Color _accentColor = Color.fromARGB(255, 22, 22, 22); // colores por defecto
  Color _backgroundColor = const Color.fromRGBO(
      235, 234, 230, 1); // colores por defecto -> fijo para el splash
  Color _textColor = const Color.fromRGBO(13, 12, 8, 1); // colores por defecto
  String _address = "Calle 123"; //direccion por defecto
  int _curretTheme = 0; //tema actual

  int get currentTheme => _curretTheme;
  String get address => _address;
  String get appName => _appName;
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get accentColor => _accentColor;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;
  List<CustomTheme> get themes => _themes;
  AppDataProvider() {
    _realTimeDb.ref().child('app').onValue.listen((event) {
      if (event.snapshot.value == null) return;

      _syncData(jsonDecode(jsonEncode(event.snapshot.value))
          as Map<dynamic, dynamic>);
      // Similarly, update other properties as needed
    });
  }

  void _syncData(Map<dynamic, dynamic> appData) {
    _appName = appData['data']['name'];
    _address = appData['data']['address'];
    _curretTheme = appData['data']['theme'];

    Map<dynamic, dynamic> themesData =
        appData['themes'] as Map<dynamic, dynamic>;
    List<CustomTheme> themes = [];
    int amount = themesData["amount"];
    for (int i = 0; i < amount; i++) {
      themes.add(CustomTheme.fromMap(themesData[i.toString()]));
    }

    _primaryColor = themes[_curretTheme].primary;
    _secondaryColor = themes[_curretTheme].secondary;
    _accentColor = themes[_curretTheme].accent;
    _backgroundColor = themes[_curretTheme].background;
    _textColor = themes[_curretTheme].text;
    _themes = themes;
    notifyListeners();
  }

  void changeAppData(String name, String address) {
    _realTimeDb.ref().child('app').update({
      'data/name': name,
      'data/address': address,
    });
  }

  void changeTheme(
    int themeIndex,
  ) {
    _realTimeDb.ref().child('app').update({
      'data/theme': themeIndex,
    });
  }
}
