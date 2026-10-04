import 'package:flutter/material.dart';

class AIProvider extends ChangeNotifier {

  bool isLoading = false;

  String result = "";

  void startLoading() {

    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {

    isLoading = false;
    notifyListeners();
  }

  void setResult(String text) {

    result = text;
    notifyListeners();
  }
}