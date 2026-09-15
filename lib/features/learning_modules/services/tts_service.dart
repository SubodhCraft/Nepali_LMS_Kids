import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      // Check if Nepali is available
      var isNepaliAvailable = await _flutterTts.isLanguageAvailable("ne-NP");
      if (isNepaliAvailable is bool && isNepaliAvailable) {
        await _flutterTts.setLanguage("ne-NP");
      } else {
        debugPrint("❌ CRITICAL: Nepali TTS (ne-NP) is NOT installed on this device!");
        debugPrint("Please install 'Nepali (Nepal)' in your device's Text-to-Speech settings.");
      }
      
      await _flutterTts.setSpeechRate(0.5); // Slower for kids
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint("Error initializing TTS: $e");
    }
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      debugPrint("TTS Speaking: $text");
      var result = await _flutterTts.speak(text);
      if (result == 0) {
        debugPrint("TTS Failed to speak. Result: $result");
      }
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

final ttsServiceProvider = Provider<TTSService>((ref) {
  return TTSService();
});
