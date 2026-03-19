import 'package:flutter/material.dart';

import '../models/phrase.dart';

class PhraseDetailScreen extends StatelessWidget {
  final Phrase phrase;

  const PhraseDetailScreen({super.key, required this.phrase});

  @override
  Widget build(BuildContext context) {
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
                  Text(phrase.english, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text('Japanese', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(phrase.japanese, style: Theme.of(context).textTheme.titleLarge),
                  if ((phrase.romaji ?? '').isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Romaji', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(phrase.romaji!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}