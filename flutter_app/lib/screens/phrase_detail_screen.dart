import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/phrase.dart';
import '../services/audio_service.dart';
import '../state/app_state.dart';
import '../widgets/phrasebook_icon.dart';

class PhraseDetailScreen extends StatefulWidget {
  final Phrase phrase;
  final AudioServiceBase? audioService;

  const PhraseDetailScreen({
    super.key,
    required this.phrase,
    this.audioService,
  });

  @override
  State<PhraseDetailScreen> createState() => _PhraseDetailScreenState();
}

class _PhraseDetailScreenState extends State<PhraseDetailScreen> {
  late final AudioServiceBase _audioService;
  String? _lastPlayedPhraseId;

  @override
  void initState() {
    super.initState();
    _audioService = widget.audioService ?? AudioService();
  }

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final shown = state.currentPhrase ?? widget.phrase;
    final isFavorite = state.isFavorite(shown);
    final played = _lastPlayedPhraseId == shown.id;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhrasebookIcon(size: 26),
            SizedBox(width: 10),
            Text('Phrase Detail'),
          ],
        ),
      ),
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
                  Text(
                    'English',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shown.english,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Japanese',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shown.japanese,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if ((shown.romaji ?? '').isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Romaji',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(shown.romaji!),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _playAudio(shown),
                        icon: Icon(played ? Icons.replay : Icons.play_arrow),
                        label: Text(played ? 'Repeat' : 'Play'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.read<AppState>().toggleFavorite(shown),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: Text(
                          isFavorite ? 'Remove Favorite' : 'Add Favorite',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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

  Future<void> _playAudio(Phrase phrase) async {
    try {
      await _audioService.speak(phrase.japanese, language: 'ja-JP');
      if (!mounted) return;
      setState(() {
        _lastPlayedPhraseId = phrase.id;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Audio unavailable: $e')));
    }
  }
}
