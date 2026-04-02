import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/phrase.dart';
import '../state/app_state.dart';

class PhraseDetailScreen extends StatelessWidget {
  final Phrase phrase;

  const PhraseDetailScreen({super.key, required this.phrase});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final shown = state.currentPhrase ?? phrase;

    return Scaffold(
      appBar: AppBar(title: const Text('Phrase Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('English', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(shown.english, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text('Japanese', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(shown.japanese, style: Theme.of(context).textTheme.titleLarge),
                  if ((shown.romaji ?? '').isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Romaji', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(shown.romaji!),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => context.read<AppState>().prevPhrase(),
                        child: const Text('Prev'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => context.read<AppState>().nextPhrase(),
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}