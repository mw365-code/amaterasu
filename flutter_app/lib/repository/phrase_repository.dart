import '../models/category.dart';
import '../models/phrase.dart';

class PhraseRepository {
  const PhraseRepository();

  List<Category> getAllCategories() => const [
        Category(id: 'food', name: 'Food'),
        Category(id: 'transport', name: 'Transport'),
      ];

  List<Phrase> getPhrasesByCategory(String categoryId) {
    const all = <Phrase>[
      Phrase(
        id: 'p1',
        categoryId: 'food',
        english: 'Water, please.',
        japanese: 'お水をください。',
        romaji: 'Omizu o kudasai.',
      ),
      Phrase(
        id: 'p2',
        categoryId: 'transport',
        english: 'Where is the station?',
        japanese: '駅はどこですか？',
        romaji: 'Eki wa doko desu ka?',
      ),
    ];
    return all.where((p) => p.categoryId == categoryId).toList();
  }
}