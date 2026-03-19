import 'package:flutter/material.dart';
import 'state/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState state = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Phrase App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          // Placeholder home until you build real screens.
          return Scaffold(
            appBar: AppBar(title: const Text('Travel Phrase App')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('App is running. Next: build screens.'),
                  const SizedBox(height: 12),
                  Text('Search query: "${state.searchQuery}"'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      ElevatedButton(
                        onPressed: () => state.setSearchQuery('hello'),
                        child: const Text('Set query'),
                      ),
                      ElevatedButton(
                        onPressed: () => state.setSearchQuery(''),
                        child: const Text('Clear query'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
