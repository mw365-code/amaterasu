import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  // These are typed as dynamic/Object? because your Phrase/Category models
  // may be implemented later. Replace with real types when you add them.
  Object? currentCategory;
  Object? currentPhrase;

  final List<Object> favorites = [];
  final List<Object> recentlyViewed = [];

  String searchQuery = '';

  List<Object> currentPhraseList = [];
  int currentPhraseIndex = -1;

  void setCategory(Object? category) {
    currentCategory = category;
    notifyListeners();
  }

  void setPhrase(Object? phrase) {
    currentPhrase = phrase;
    _addToRecentlyViewed(phrase);
    notifyListeners();
  }

  void setPhraseContext(List<Object>? phrases, Object phrase) {
    currentPhraseList = List<Object>.from(phrases ?? const []);
    currentPhraseIndex = currentPhraseList.indexOf(phrase);
    setPhrase(phrase);
  }

  Object? nextPhrase() {
    if (currentPhraseList.isEmpty) return null;

    if (currentPhraseIndex < 0) {
      currentPhraseIndex = 0;
    } else {
      currentPhraseIndex = (currentPhraseIndex + 1).clamp(0, currentPhraseList.length - 1);
    }

    setPhrase(currentPhraseList[currentPhraseIndex]);
    return currentPhrase;
  }

  Object? prevPhrase() {
    if (currentPhraseList.isEmpty) return null;

    if (currentPhraseIndex < 0) {
      currentPhraseIndex = 0;
    } else {
      currentPhraseIndex = (currentPhraseIndex - 1).clamp(0, currentPhraseList.length - 1);
    }

    setPhrase(currentPhraseList[currentPhraseIndex]);
    return currentPhrase;
  }

  void toggleFavorite(Object phrase) {
    if (favorites.contains(phrase)) {
      favorites.remove(phrase);
    } else {
      favorites.add(phrase);
    }
    notifyListeners();
  }

  bool isFavorite(Object phrase) => favorites.contains(phrase);

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void _addToRecentlyViewed(Object? phrase) {
    if (phrase == null) return;

    recentlyViewed.remove(phrase);
    recentlyViewed.insert(0, phrase);

    if (recentlyViewed.length > 20) {
      recentlyViewed.removeLast();
    }
  }
}