import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/theme/palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit Clone',
      theme: Palette.darkModeAppTheme,
      home: const SizedBox(),
    );
  }
}
