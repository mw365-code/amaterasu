import 'package:flutter/material.dart';
import 'package:flutter_app/screens/phrase_detail_screen.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/phrase.dart';
import '../repository/phrase_repository.dart';
import '../state/app_state.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final repo = PhraseRepository();

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: FutureBuilder<List<Phrase>>(
        future: repo.getPhrasesByCategory(category.id),
        builder: (context, snapshot) {
          final phrases = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load phrases: ${snapshot.error}'));
          }
          if (phrases == null || phrases.isEmpty) {
            return const Center(child: Text('No phrases found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: phrases.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final p = phrases[i];
              return ListTile(
                title: Text(p.english),
                subtitle: Text(p.japanese),
                onTap: () {
                  context.read<AppState>().setPhraseContext(phrases, p);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PhraseDetailScreen(phrase: p),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}