import 'dart:math';

/// A single combination: base letter + matra => result
class MatraCombo {
  final String baseLetter;
  final String matraDisplay; // Display version e.g. '◌ा'
  final String matraActual;  // Actual combining matra char e.g. 'ा'
  final String result;       // Combined letter e.g. 'का'
  final String hint;         // Romanized hint e.g. 'Kaa'
  final String emoji;        // Associated emoji

  const MatraCombo({
    required this.baseLetter,
    required this.matraDisplay,
    required this.matraActual,
    required this.result,
    required this.hint,
    required this.emoji,
  });
}

class MatraData {
  final String display;
  final String actual;
  final String suffixHint;
  final String emoji;

  const MatraData(this.display, this.actual, this.suffixHint, this.emoji);
}

class BaseLetterData {
  final String letter;
  final String romanized;

  const BaseLetterData(this.letter, this.romanized);
}

/// Dynamic generator for Matra combinations.
class MatraCombos {
  MatraCombos._();

  static const List<MatraData> allMatras = [
    MatraData('◌ा', 'ा', 'aa', '✨'),
    MatraData('◌ि', 'ि', 'i', '⭐'),
    MatraData('◌ी', 'ी', 'ee', '🌟'),
    MatraData('◌ु', 'ु', 'u', '💫'),
    MatraData('◌े', 'े', 'e', '🌈'),
    MatraData('◌ो', 'ो', 'o', '🎈'),
  ];

  static const List<BaseLetterData> allConsonants = [
    BaseLetterData('क', 'K'),
    BaseLetterData('ख', 'Kh'),
    BaseLetterData('ग', 'G'),
    BaseLetterData('घ', 'Gh'),
    BaseLetterData('च', 'Ch'),
    BaseLetterData('छ', 'Chh'),
    BaseLetterData('ज', 'J'),
    BaseLetterData('ट', 'T'),
    BaseLetterData('त', 'T'),
    BaseLetterData('थ', 'Th'),
    BaseLetterData('द', 'D'),
    BaseLetterData('ध', 'Dh'),
    BaseLetterData('न', 'N'),
    BaseLetterData('प', 'P'),
    BaseLetterData('फ', 'Ph'),
    BaseLetterData('ब', 'B'),
    BaseLetterData('भ', 'Bh'),
    BaseLetterData('म', 'M'),
    BaseLetterData('य', 'Y'),
    BaseLetterData('र', 'R'),
    BaseLetterData('ल', 'L'),
    BaseLetterData('व', 'V'),
    BaseLetterData('स', 'S'),
    BaseLetterData('ह', 'H'),
  ];

  static BaseLetterData getRandomBaseLetter() {
    final random = Random();
    return allConsonants[random.nextInt(allConsonants.length)];
  }

  static List<MatraCombo> generateCombos(BaseLetterData base) {
    return allMatras.map((m) => MatraCombo(
      baseLetter: base.letter,
      matraDisplay: m.display,
      matraActual: m.actual,
      result: '${base.letter}${m.actual}',
      hint: '${base.romanized}${m.suffixHint}',
      emoji: m.emoji,
    )).toList();
  }
}
