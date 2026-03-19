import 'package:flutter/material.dart';
import 'package:flutter_app/screens/phrase_detail_screen.dart';

import '../models/category.dart';
import '../repository/phrase_repository.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final repo = PhraseRepository();
    final phrases = repo.getPhrasesByCategory(category.id);

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: phrases.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final p = phrases[i];
          return ListTile(
            title: Text(p.english),
            subtitle: Text(p.japanese),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PhraseDetailScreen(phrase: p),
                ),
              );
            },
          );
        },
      ),
    );
  }
}