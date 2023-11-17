import 'package:flutter/material.dart';

final ThemeData hipHopTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 29, 32, 44),
  backgroundColor: const Color.fromARGB(255, 29, 32, 44),
  canvasColor: const Color.fromARGB(255, 29, 32, 44),
  cardColor: Colors.black,
  dividerColor: Colors.grey, // Use gray for dividers

  // Set text colors to white
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white), // Style for app bar title
  ),
  primaryTextTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white), // Style for app bar title
  ),
);
