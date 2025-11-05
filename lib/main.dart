import 'package:expenses_wise/widgets/splash_screen/splash.dart';
import 'package:flutter/material.dart';

var kColorscheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 204, 255),
);

var kDarkMode = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFFE53935),
);

void main() {
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkMode,
        cardTheme: const CardTheme().copyWith(
          color: kDarkMode.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkMode.primaryContainer,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorscheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color.fromARGB(255, 0, 106, 255),
          foregroundColor: kColorscheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorscheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorscheme.primaryContainer,
            foregroundColor: Colors.black,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.normal,
            color: kColorscheme.onSecondaryContainer,
            fontSize: 16,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    ),
  );
}
