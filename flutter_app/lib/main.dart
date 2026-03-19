import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';

void main() {
  runApp(const TravelPhraseApp());
}

class TravelPhraseApp extends StatelessWidget {
  const TravelPhraseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Phrases',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}