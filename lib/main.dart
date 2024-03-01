import 'package:flutter/material.dart';

import 'screens/grocery_list.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

const Color kSeedColor = Color.fromARGB(255, 147, 229, 250);

final kMyTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.dark,
    surface: const Color.fromARGB(255, 42, 51, 59),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 55, 58, 60),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Groceries",
      theme: kMyTheme,
      home: const HomeScreen(),
    );
  }
}
