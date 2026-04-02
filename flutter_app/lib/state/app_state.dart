import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../models/category.dart';
import '../models/phrase.dart';

class AppState extends ChangeNotifier {
  Category? currentCategory;
  Phrase? currentPhrase;

  final List<Phrase> favorites = [];
  final List<Phrase> recentlyViewed = [];

  String searchQuery = '';

  List<Phrase> currentPhraseList = [];
  int currentPhraseIndex = -1;

  void setCategory(Category? category) {
    currentCategory = category;
    notifyListeners();
  }

  void setPhrase(Phrase? phrase) {
    currentPhrase = phrase;
    _addToRecentlyViewed(phrase);
    notifyListeners();
  }

  void setPhraseContext(List<Phrase> phrases, Phrase phrase) {
    currentPhraseList = List<Phrase>.from(phrases);
    currentPhraseIndex = currentPhraseList.indexOf(phrase);
    setPhrase(phrase);
  }

  Phrase? nextPhrase() {
    if (currentPhraseList.isEmpty) return null;

    if (currentPhraseIndex < 0) {
      currentPhraseIndex = 0;
    } else {
      currentPhraseIndex = (currentPhraseIndex + 1).clamp(0, currentPhraseList.length - 1);
    }

    final phrase = currentPhraseList[currentPhraseIndex];
    setPhrase(phrase);
    return phrase;
  }

  Phrase? prevPhrase() {
    if (currentPhraseList.isEmpty) return null;

    if (currentPhraseIndex < 0) {
      currentPhraseIndex = 0;
    } else {
      currentPhraseIndex = (currentPhraseIndex - 1).clamp(0, currentPhraseList.length - 1);
    }

    final phrase = currentPhraseList[currentPhraseIndex];
    setPhrase(phrase);
    return phrase;
  }

  void toggleFavorite(Phrase phrase) {
    if (favorites.contains(phrase)) {
      favorites.remove(phrase);
    } else {
      favorites.add(phrase);
    }
    notifyListeners();
  }

  bool isFavorite(Phrase phrase) => favorites.contains(phrase);

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void _addToRecentlyViewed(Phrase? phrase) {
    if (phrase == null) return;

    recentlyViewed.remove(phrase);
    recentlyViewed.insert(0, phrase);

    if (recentlyViewed.length > 20) {
      recentlyViewed.removeLast();
    }
  }
}