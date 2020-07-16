import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppThemeState extends ChangeNotifier {
  bool isDark =
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

  bool get getDarkStatus{
    return isDark;
  }

  void changeTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
