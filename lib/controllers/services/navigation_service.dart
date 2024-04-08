import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String routeName) {
    navigatorKey.currentState?.popAndPushNamed(routeName);
  }

  void navigateToRoute(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  void navigateToPage(Widget page) {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
