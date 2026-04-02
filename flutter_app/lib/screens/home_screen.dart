import 'package:flutter/material.dart';

import '../models/category.dart';
import '../repository/phrase_repository.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PhraseRepository();

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Phrases')),
      body: FutureBuilder<List<Category>>(
        future: repo.getAllCategories(),
        builder: (context, snapshot) {
          final categories = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load categories: ${snapshot.error}'));
          }
          if (categories == null || categories.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final c = categories[i];
              return ListTile(
                title: Text(c.name),
                subtitle: c.description.isNotEmpty ? Text(c.description) : null,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CategoryScreen(category: c),
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