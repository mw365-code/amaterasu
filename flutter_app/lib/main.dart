import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const TravelPhraseApp(),
    ),
  );
}

class TravelPhraseApp extends StatelessWidget {
  const TravelPhraseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japan: Help Me',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
