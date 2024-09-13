import 'package:flutter/material.dart';

class ThemeSettings {
  static ThemeData lightTheme(){
    final theme= ThemeData.light();
    return theme.copyWith(
      scaffoldBackgroundColor: Colors.white,
      
    );

  }
  static ThemeData darkTheme(){
    final theme= ThemeData.dark();
    return theme.copyWith();
  }

  static ThemeData warmTheme(){
    final theme = ThemeData.light();
    return theme.copyWith();
  }
}