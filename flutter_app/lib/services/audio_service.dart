import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

abstract class AudioServiceBase {
  Future<void> speak(String text, {String language});
  Future<void> stop();
}

class AudioService implements AudioServiceBase {
  final FlutterTts _tts = FlutterTts();
  bool _configured = false;

  @override
  Future<void> speak(String text, {String language = 'ja-JP'}) async {
    if (text.trim().isEmpty) return;

    await _ensureConfigured(language: language);
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> _ensureConfigured({required String language}) async {
    if (_configured) return;

    try {
      await _tts.awaitSpeakCompletion(true);
      final available = await _tts.isLanguageAvailable(language);
      if (available == false) {
        throw UnsupportedError(
          'Language $language is not available on this device.',
        );
      }
      await _tts.setLanguage(language);
      _configured = true;
    } on PlatformException catch (e) {
      throw UnsupportedError(
        e.message ?? 'Text-to-speech is not available on this device.',
      );
    }
  }
}
