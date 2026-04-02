// flutter_app/lib/services/phrase_catalog.dart
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import '../models/category.dart';
import '../models/phrase.dart';

class PhraseCatalog {
  final List<Category> categories;
  final List<Phrase> phrases;

  const PhraseCatalog({
    required this.categories,
    required this.phrases,
  });

  static Future<PhraseCatalog> loadFromAssets({
    String assetPath = 'assets/phrases.yaml',
  }) async {
    final raw = await rootBundle.loadString(assetPath);
    final yamlDoc = loadYaml(raw);

    // Convert YamlMap/YamlList into plain Dart Map/List via JSON roundtrip.
    final map = jsonDecode(jsonEncode(yamlDoc)) as Map<String, dynamic>;

    final categoriesRaw = (map['categories'] as List<dynamic>? ?? const []);
    final phrasesRaw = (map['phrases'] as List<dynamic>? ?? const []);

    final categories = categoriesRaw
        .whereType<Map<String, dynamic>>()
        .map(Category.fromMap)
        .toList(growable: false);

    final phrases = phrasesRaw
        .whereType<Map<String, dynamic>>()
        .map(Phrase.fromMap)
        .toList(growable: false);

    return PhraseCatalog(categories: categories, phrases: phrases);
  }
}