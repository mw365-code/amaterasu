import 'package:flutter/foundation.dart';

class TranslationService {
  String translate(String text, {String targetLanguage = 'ja'}) {
    // Placeholder (Phase 4)
    // Keep similar behavior: log then throw.
    // In Flutter, print() is okay for simple debugging.
    debugPrint(
      '[TranslationService] translate() called: target=$targetLanguage, text="$text"',
    );
    throw UnimplementedError('AI translation coming in Phase 4.');
  }
}