import 'package:flutter/material.dart';
import 'package:powerdiary/ui/pages/theme/colors.dart';

@immutable
class AppTheme {
  static const colours = AppColours();
  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
      fontFamily: " ",
      primaryColor: Color(0xFFFFFFFF),
    );
  }
}
