import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapnavigatorapp/shared/visual/app_colors.dart';

class DefaultTheme {
  static final ThemeData themeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: kPrimaryColor,
    secondaryHeaderColor: kSecondaryColor,
    scaffoldBackgroundColor: kBackgroundColor,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    textTheme: TextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kDetailColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      ),
    ),
  );
}
