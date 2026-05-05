import 'package:flutter/material.dart';
import 'package:flutter_app/screens/phrase_detail_screen.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/phrase.dart';
import '../repository/phrase_repository.dart';
import '../services/search_service.dart';
import '../state/app_state.dart';
import '../widgets/phrasebook_icon.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  final PhraseRepository? repository;

  const CategoryScreen({super.key, required this.category, this.repository});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final SearchService<Phrase> _searchService = SearchService<Phrase>();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final repo = widget.repository ?? PhraseRepository();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PhrasebookIcon(size: 26),
            const SizedBox(width: 10),
            Flexible(child: Text(widget.category.name)),
          ],
        ),
      ),
      body: FutureBuilder<List<Phrase>>(
        future: repo.getPhrasesByCategory(widget.category.id),
        builder: (context, snapshot) {
          final phrases = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load phrases: ${snapshot.error}'),
            );
          }
          if (phrases == null || phrases.isEmpty) {
            return const Center(child: Text('No phrases found.'));
          }

          final filtered = _searchService.search(
            items: phrases,
            query: _query,
            matchesQuery: _matchesPhrase,
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search phrases',
                    hintText: 'Type English, Japanese, Romaji, or tags',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                    context.read<AppState>().setSearchQuery(value);
                  },
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No phrases found.'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final p = filtered[i];
                          return ListTile(
                            title: Text(p.english),
                            subtitle: Text(p.japanese),
                            onTap: () {
                              context.read<AppState>().setPhraseContext(
                                filtered,
                                p,
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PhraseDetailScreen(phrase: p),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _matchesPhrase(Phrase phrase, String query) {
    final q = query.toLowerCase();
    final english = phrase.english.toLowerCase();
    final japanese = phrase.japanese.toLowerCase();
    final romaji = (phrase.romaji ?? '').toLowerCase();
    final notes = (phrase.notes ?? '').toLowerCase();
    final tags = phrase.tags.map((tag) => tag.toLowerCase());

    if (english.contains(q)) return true;
    if (japanese.contains(q)) return true;
    if (romaji.contains(q)) return true;
    if (notes.contains(q)) return true;
    return tags.any((tag) => tag.contains(q));
  }
}
