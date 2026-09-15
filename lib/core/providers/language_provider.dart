import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { en, ne }

class LanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() {
    // Default to Nepali based on the app's primary audience
    return AppLanguage.ne;
  }

  void setLanguage(AppLanguage language) {
    state = language;
  }

  void toggleLanguage() {
    state = state == AppLanguage.en ? AppLanguage.ne : AppLanguage.en;
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, AppLanguage>(() {
  return LanguageNotifier();
});
