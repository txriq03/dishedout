// filepath: d:\Projects\dishedout\lib\shared\theme.dart
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  progressIndicatorTheme: ProgressIndicatorThemeData(year2023: false),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
      TargetPlatform.values,
      value: (_) => const FadeForwardsPageTransitionsBuilder(),
    ),
  ),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    primary: Colors.deepOrange.shade400,
    onPrimary: Colors.grey.shade800,
    secondaryContainer: Colors.deepOrange.shade300,
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w200),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(
        ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ).surfaceContainer,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 12),
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(15),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(15),
    ),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.04),
    labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    hintStyle: TextStyle(color: Colors.grey[700]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.deepOrange.shade200,
    ),
  ),
);

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.indigo,
  brightness: Brightness.light,
  primary: Colors.deepOrange,
);
