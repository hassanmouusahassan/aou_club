// user_data.dart
import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String _userName = 'Default Name';

  String get userName => _userName;

  void setUserName(String newName) {
    _userName = newName;
    notifyListeners();
  }
}
