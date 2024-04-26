import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void setLoading(bool value) {
    isLoading.value = value;
    notifyListeners();
  }
}
