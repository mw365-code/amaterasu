import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/models/phrase.dart';
import 'package:flutter_app/repository/phrase_repository.dart';
import 'package:flutter_app/screens/category_screen.dart';
import 'package:flutter_app/state/app_state.dart';
import 'package:provider/provider.dart';

class _FakePhraseRepository extends PhraseRepository {
  _FakePhraseRepository(this._phrases);

  final List<Phrase> _phrases;

  @override
  Future<List<Phrase>> getPhrasesByCategory(String categoryId) async {
    return _phrases
        .where((p) => p.categoryId == categoryId)
        .toList(growable: false);
  }
}

void main() {
  testWidgets('Category screen filters phrase list from search query', (
    WidgetTester tester,
  ) async {
    final category = Category(id: 'food', name: 'Food');
    final phrases = <Phrase>[
      const Phrase(
        id: 'p1',
        categoryId: 'food',
        english: 'Hello',
        japanese: 'こんにちは',
        romaji: 'konnichiwa',
      ),
      const Phrase(
        id: 'p2',
        categoryId: 'food',
        english: 'Thank you',
        japanese: 'ありがとう',
        romaji: 'arigatou',
      ),
    ];

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: MaterialApp(
          home: CategoryScreen(
            category: category,
            repository: _FakePhraseRepository(phrases),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Thank you'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'arigatou');
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsNothing);
    expect(find.text('Thank you'), findsOneWidget);
  });
}
