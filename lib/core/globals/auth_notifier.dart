import 'package:flutter/foundation.dart';

class AuthNotifier extends ChangeNotifier {
  void notifyAuthChanged() {
    notifyListeners();
  }
}
