

import 'package:flutter/material.dart';

class ThemeSwitcher {

  static final ThemeSwitcher _TS = new ThemeSwitcher._internal();
  ThemeSwitcher._internal();
  static ThemeSwitcher get instance => _TS;
  static var _themeSwitcher;

  ThemeData get theme {
    if(_themeSwitcher != null) return _themeSwitcher;
    _themeSwitcher = _init();
    return _themeSwitcher;
  }

  ThemeData _init() {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(151, 0, 0, 1.0)
    );
  }

}