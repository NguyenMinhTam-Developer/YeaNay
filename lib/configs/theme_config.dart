import 'package:flutter/material.dart';

class ColorConfig {
  static const Color primaryColor = Color(0xFFFF7643);
  static const Color secondaryColor = Color(0xFF979797);
}

class SizeConfig {
  static const double margin = 16;
  static const double padding = 16;
  static const double borderRadius = 16;
}

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: ColorConfig.primaryColor,
      secondary: ColorConfig.secondaryColor,
    ),
    appBarTheme: _appBarTheme,
    inputDecorationTheme: _inputDecoration,
    textSelectionTheme: _textSelectionTheme,
    buttonTheme: _buttonTheme,
    cardTheme: _cardTheme,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: ColorConfig.primaryColor,
      secondary: ColorConfig.secondaryColor,
    ),
    appBarTheme: _appBarTheme,
    inputDecorationTheme: _inputDecoration,
    textSelectionTheme: _textSelectionTheme,
    buttonTheme: _buttonTheme,
    cardTheme: _cardTheme,
  );

  // ==================================================================================================== //

  // App Bar Theme
  static const _appBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 1,
    color: Colors.white,
    foregroundColor: Colors.black,
  );

  // Button Theme
  static final ButtonThemeData _buttonTheme = ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.borderRadius)),
    padding: const EdgeInsets.symmetric(horizontal: SizeConfig.padding, vertical: SizeConfig.padding / 2),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  // Card Theme
  static final CardTheme _cardTheme = CardTheme(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.borderRadius)),
  );

  // Input Decoration Theme
  static final _inputDecoration = InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: SizeConfig.padding, vertical: SizeConfig.padding / 2),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.borderRadius),
      gapPadding: 10,
    ),
  );

  // Text Select Theme
  static const TextSelectionThemeData _textSelectionTheme = TextSelectionThemeData(
    cursorColor: ColorConfig.primaryColor,
  );
}
