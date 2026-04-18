import 'package:flutter/material.dart';

void main() {
  runApp(const ThaChinChordApp());
}

class ThaChinChordApp extends StatelessWidget {
  const ThaChinChordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThaChinChord',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
