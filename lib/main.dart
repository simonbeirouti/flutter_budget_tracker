import 'package:flutter/material.dart';

import 'package:budget_tracker/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        // Primary color for the app
        primarySwatch: Colors.blue,
        // Add a color scheme which makes things nicer / add a dark mode also
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark, seedColor: Colors.indigo),
      ),
      home: const Home(),
    );
  }
}
