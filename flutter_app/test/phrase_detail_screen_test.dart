import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/phrase.dart';
import 'package:flutter_app/screens/phrase_detail_screen.dart';
import 'package:flutter_app/services/audio_service.dart';
import 'package:flutter_app/state/app_state.dart';
import 'package:provider/provider.dart';

class _FakeAudioService implements AudioServiceBase {
  int speakCalls = 0;
  int stopCalls = 0;

  @override
  Future<void> speak(String text, {String language = 'ja-JP'}) async {
    speakCalls += 1;
  }

  @override
  Future<void> stop() async {
    stopCalls += 1;
  }
}

void main() {
  late Phrase phrase;

  setUp(() {
    phrase = const Phrase(
      id: 'p1',
      categoryId: 'food',
      english: 'Thank you',
      japanese: 'ありがとう',
      romaji: 'arigatou',
    );
  });

  testWidgets('Favorite button toggles label and state', (
    WidgetTester tester,
  ) async {
    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(home: PhraseDetailScreen(phrase: phrase)),
      ),
    );

    expect(find.text('Add Favorite'), findsOneWidget);
    expect(appState.isFavorite(phrase), isFalse);

    await tester.tap(find.text('Add Favorite'));
    await tester.pumpAndSettle();

    expect(find.text('Remove Favorite'), findsOneWidget);
    expect(appState.isFavorite(phrase), isTrue);
  });

  testWidgets('Play button switches to repeat after successful playback', (
    WidgetTester tester,
  ) async {
    final appState = AppState();
    final fakeAudio = _FakeAudioService();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          home: PhraseDetailScreen(phrase: phrase, audioService: fakeAudio),
        ),
      ),
    );

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Repeat'), findsNothing);

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(fakeAudio.speakCalls, 1);
    expect(find.text('Repeat'), findsOneWidget);
  });
}
