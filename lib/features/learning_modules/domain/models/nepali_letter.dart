/// Represents a single Nepali letter with its example word and image asset.
class NepaliLetter {
  final String id;         // Unique ID e.g. "vowel_01"
  final String letter;     // The Nepali letter e.g. "अ"
  final String romanized;  // Romanized name e.g. "A"
  final String exampleWordNepali;   // e.g. "अम्बा"
  final String exampleWordEnglish;  // e.g. "Guava"
  final String emoji;      // Fallback display emoji e.g. "🍈"
  final String? imagePath; // Asset path e.g. "assets/images/letters/amba.png" (null if missing)

  const NepaliLetter({
    required this.id,
    required this.letter,
    required this.romanized,
    required this.exampleWordNepali,
    required this.exampleWordEnglish,
    required this.emoji,
    this.imagePath,
  });
}

/// Represents a section of the alphabet lesson (e.g., Vowels or Consonants).
class AlphabetSection {
  final String id;
  final String titleNepali;
  final String titleEnglish;
  final String emoji;
  final String gradientStart;
  final String gradientEnd;
  final List<NepaliLetter> letters;

  const AlphabetSection({
    required this.id,
    required this.titleNepali,
    required this.titleEnglish,
    required this.emoji,
    required this.gradientStart,
    required this.gradientEnd,
    required this.letters,
  });
}
