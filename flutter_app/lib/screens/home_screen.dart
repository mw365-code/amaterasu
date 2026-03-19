import 'package:flutter/material.dart';

import '../repository/phrase_repository.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PhraseRepository();
    final categories = repo.getAllCategories();

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Phrases')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final c = categories[i];
          return ListTile(
            title: Text(c.name),
            subtitle: (c.description?.isNotEmpty ?? false) ? Text(c.description!) : null,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryScreen(category: c),
                ),
              );
            },
          );
        },
      ),
    );
  }
}