import '../models/category.dart';
import '../models/phrase.dart';
import '../services/phrase_catalog.dart';

class PhraseRepository {
  PhraseCatalog? _cache;

  Future<PhraseCatalog> _catalog() async {
    final cached = _cache;
    if (cached != null) return cached;

    final loaded = await PhraseCatalog.loadFromAssets();
    _cache = loaded;
    return loaded;
  }

  Future<List<Category>> getAllCategories() async {
    final c = await _catalog();
    return c.categories;
  }

  Future<List<Phrase>> getPhrasesByCategory(String categoryId) async {
    final c = await _catalog();
    return c.phrases.where((p) => p.categoryId == categoryId).toList(growable: false);
  }
}