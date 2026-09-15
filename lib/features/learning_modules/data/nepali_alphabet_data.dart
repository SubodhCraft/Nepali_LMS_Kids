import '../domain/models/nepali_letter.dart';

/// Complete static data for all Nepali alphabet letters.
/// Contains 13 vowels (स्वरहरू) and 36 consonants (व्यञ्जनहरू).
/// Updated to use standard, authentic Nepali vocabulary.
class NepaliAlphabetData {
  NepaliAlphabetData._();

  static const List<AlphabetSection> sections = [
    AlphabetSection(
      id: 'vowels',
      titleNepali: 'स्वरहरू',
      titleEnglish: 'Vowels',
      emoji: '🌈',
      gradientStart: '#7E57C2',
      gradientEnd: '#B39DDB',
      letters: _vowels,
    ),
    AlphabetSection(
      id: 'consonants',
      titleNepali: 'व्यञ्जनहरू',
      titleEnglish: 'Consonants',
      emoji: '🔤',
      gradientStart: '#FF7B54',
      gradientEnd: '#FFB347',
      letters: _consonants,
    ),
    AlphabetSection(
      id: 'maatras',
      titleNepali: 'मात्रा र बिन्दु',
      titleEnglish: 'Modifiers (Maatras)',
      emoji: '✨',
      gradientStart: '#42A5F5',
      gradientEnd: '#26C6DA',
      letters: _maatras,
    ),
  ];

  // ─── 13 Vowels (स्वरहरू) ────────────────────────────────────────────────────
  static const List<NepaliLetter> _vowels = [
    NepaliLetter(
      id: 'vowel_a',
      letter: 'अ',
      romanized: 'A',
      exampleWordNepali: 'अम्बा',
      exampleWordEnglish: 'Guava',
      emoji: '🍈',

    ),
    NepaliLetter(
      id: 'vowel_aa',
      letter: 'आ',
      romanized: 'Aa',
      exampleWordNepali: 'आँप',
      exampleWordEnglish: 'Mango',
      emoji: '🥭',

    ),
    NepaliLetter(
      id: 'vowel_i',
      letter: 'इ',
      romanized: 'I',
      exampleWordNepali: 'इन्द्रेणी',
      exampleWordEnglish: 'Rainbow',
      emoji: '🌈',

    ),
    NepaliLetter(
      id: 'vowel_ii',
      letter: 'ई',
      romanized: 'Ii',
      exampleWordNepali: 'ईश्वर',
      exampleWordEnglish: 'God',
      emoji: '🕉️',

    ),
    NepaliLetter(
      id: 'vowel_u',
      letter: 'उ',
      romanized: 'U',
      exampleWordNepali: 'उखु',
      exampleWordEnglish: 'Sugarcane',
      emoji: '🎋',

    ),
    NepaliLetter(
      id: 'vowel_uu',
      letter: 'ऊ',
      romanized: 'Uu',
      exampleWordNepali: 'ऊन',
      exampleWordEnglish: 'Wool',
      emoji: '🧶',

    ),
    NepaliLetter(
      id: 'vowel_ri',
      letter: 'ऋ',
      romanized: 'Ri',
      exampleWordNepali: 'ऋषि',
      exampleWordEnglish: 'Sage',
      emoji: '🧙',

    ),
    NepaliLetter(
      id: 'vowel_e',
      letter: 'ए',
      romanized: 'E',
      exampleWordNepali: 'एक',
      exampleWordEnglish: 'One',
      emoji: '1️⃣',

    ),
    NepaliLetter(
      id: 'vowel_ai',
      letter: 'ऐ',
      romanized: 'Ai',
      exampleWordNepali: 'ऐना',
      exampleWordEnglish: 'Mirror',
      emoji: '🪞',

    ),
    NepaliLetter(
      id: 'vowel_o',
      letter: 'ओ',
      romanized: 'O',
      exampleWordNepali: 'ओखर',
      exampleWordEnglish: 'Walnut',
      emoji: '🌰',

    ),
    NepaliLetter(
      id: 'vowel_au',
      letter: 'औ',
      romanized: 'Au',
      exampleWordNepali: 'औंठी',
      exampleWordEnglish: 'Ring',
      emoji: '💍',

    ),
    NepaliLetter(
      id: 'vowel_am',
      letter: 'अं',
      romanized: 'Am',
      exampleWordNepali: 'अङ्गुर',
      exampleWordEnglish: 'Grapes',
      emoji: '🍇',

    ),
    NepaliLetter(
      id: 'vowel_ah',
      letter: 'अः',
      romanized: 'Ah',
      exampleWordNepali: 'नमः',
      exampleWordEnglish: 'Salutation',
      emoji: '🙏',

    ),
  ];

  // ─── 36 Consonants (व्यञ्जनहरू) ─────────────────────────────────────────────
  static const List<NepaliLetter> _consonants = [
    NepaliLetter(
      id: 'con_ka',
      letter: 'क',
      romanized: 'Ka',
      exampleWordNepali: 'कछुवा',
      exampleWordEnglish: 'Turtle',
      emoji: '🐢',

    ),
    NepaliLetter(
      id: 'con_kha',
      letter: 'ख',
      romanized: 'Kha',
      exampleWordNepali: 'खरायो',
      exampleWordEnglish: 'Rabbit',
      emoji: '🐰',
      imagePath: 'assets/images/letters/kharayo.png',
    ),
    NepaliLetter(
      id: 'con_ga',
      letter: 'ग',
      romanized: 'Ga',
      exampleWordNepali: 'गमला',
      exampleWordEnglish: 'Flowerpot',
      emoji: '🪴',

    ),
    NepaliLetter(
      id: 'con_gha',
      letter: 'घ',
      romanized: 'Gha',
      exampleWordNepali: 'घर',
      exampleWordEnglish: 'House',
      emoji: '🏠',
      imagePath: 'assets/images/letters/ghar.png',
    ),
    NepaliLetter(
      id: 'con_nga',
      letter: 'ङ',
      romanized: 'Nga',
      exampleWordNepali: 'ङ्याउरो',
      exampleWordEnglish: 'Cat (Meow)',
      emoji: '🐱',

    ),
    NepaliLetter(
      id: 'con_cha',
      letter: 'च',
      romanized: 'Cha',
      exampleWordNepali: 'चरा',
      exampleWordEnglish: 'Bird',
      emoji: '🐦',

    ),
    NepaliLetter(
      id: 'con_chha',
      letter: 'छ',
      romanized: 'Chha',
      exampleWordNepali: 'छाता',
      exampleWordEnglish: 'Umbrella',
      emoji: '☂️',

    ),
    NepaliLetter(
      id: 'con_ja',
      letter: 'ज',
      romanized: 'Ja',
      exampleWordNepali: 'जहाज',
      exampleWordEnglish: 'Airplane',
      emoji: '✈️',

    ),
    NepaliLetter(
      id: 'con_jha',
      letter: 'झ',
      romanized: 'Jha',
      exampleWordNepali: 'झोला',
      exampleWordEnglish: 'Bag',
      emoji: '🎒',

    ),
    NepaliLetter(
      id: 'con_nya',
      letter: 'ञ',
      romanized: 'Nya',
      exampleWordNepali: 'ञ्याउली',
      exampleWordEnglish: 'Bird',
      emoji: '🐦',

    ),
    NepaliLetter(
      id: 'con_ta',
      letter: 'ट',
      romanized: 'Ta',
      exampleWordNepali: 'टोपी',
      exampleWordEnglish: 'Cap',
      emoji: '🧢',

    ),
    NepaliLetter(
      id: 'con_tha',
      letter: 'ठ',
      romanized: 'Tha',
      exampleWordNepali: 'ठेकी',
      exampleWordEnglish: 'Wooden Vessel',
      emoji: '🏺',

    ),
    NepaliLetter(
      id: 'con_da',
      letter: 'ड',
      romanized: 'Da',
      exampleWordNepali: 'डमरु',
      exampleWordEnglish: 'Drum',
      emoji: '🥁',

    ),
    NepaliLetter(
      id: 'con_dha',
      letter: 'ढ',
      romanized: 'Dha',
      exampleWordNepali: 'ढुकुर',
      exampleWordEnglish: 'Dove',
      emoji: '🕊️',

    ),
    NepaliLetter(
      id: 'con_na_dot',
      letter: 'ण',
      romanized: 'Na',
      exampleWordNepali: 'बाण',
      exampleWordEnglish: 'Arrow',
      emoji: '🏹',

    ),
    NepaliLetter(
      id: 'con_ta2',
      letter: 'त',
      romanized: 'Ta',
      exampleWordNepali: 'तराजु',
      exampleWordEnglish: 'Weighing Scale',
      emoji: '⚖️',

    ),
    NepaliLetter(
      id: 'con_tha2',
      letter: 'थ',
      romanized: 'Tha',
      exampleWordNepali: 'थाल',
      exampleWordEnglish: 'Plate',
      emoji: '🍽️',

    ),
    NepaliLetter(
      id: 'con_da2',
      letter: 'द',
      romanized: 'Da',
      exampleWordNepali: 'दियो',
      exampleWordEnglish: 'Oil Lamp',
      emoji: '🪔',

    ),
    NepaliLetter(
      id: 'con_dha2',
      letter: 'ध',
      romanized: 'Dha',
      exampleWordNepali: 'धनुष',
      exampleWordEnglish: 'Bow & Arrow',
      emoji: '🏹',

    ),
    NepaliLetter(
      id: 'con_na',
      letter: 'न',
      romanized: 'Na',
      exampleWordNepali: 'नरिवल',
      exampleWordEnglish: 'Coconut',
      emoji: '🥥',

    ),
    NepaliLetter(
      id: 'con_pa',
      letter: 'प',
      romanized: 'Pa',
      exampleWordNepali: 'परेवा',
      exampleWordEnglish: 'Pigeon',
      emoji: '🕊️',

    ),
    NepaliLetter(
      id: 'con_pha',
      letter: 'फ',
      romanized: 'Pha',
      exampleWordNepali: 'फर्सी',
      exampleWordEnglish: 'Pumpkin',
      emoji: '🎃',

    ),
    NepaliLetter(
      id: 'con_ba',
      letter: 'ब',
      romanized: 'Ba',
      exampleWordNepali: 'बाघ',
      exampleWordEnglish: 'Tiger',
      emoji: '🐯',
      imagePath: 'assets/images/letters/bagh.png',
    ),
    NepaliLetter(
      id: 'con_bha',
      letter: 'भ',
      romanized: 'Bha',
      exampleWordNepali: 'भालु',
      exampleWordEnglish: 'Bear',
      emoji: '🐻',

    ),
    NepaliLetter(
      id: 'con_ma',
      letter: 'म',
      romanized: 'Ma',
      exampleWordNepali: 'मादल',
      exampleWordEnglish: 'Madal (Drum)',
      emoji: '🪘',

    ),
    NepaliLetter(
      id: 'con_ya',
      letter: 'य',
      romanized: 'Ya',
      exampleWordNepali: 'याक',
      exampleWordEnglish: 'Yak',
      emoji: '🐂',

    ),
    NepaliLetter(
      id: 'con_ra',
      letter: 'र',
      romanized: 'Ra',
      exampleWordNepali: 'रथ',
      exampleWordEnglish: 'Chariot',
      emoji: '🛕',

    ),
    NepaliLetter(
      id: 'con_la',
      letter: 'ल',
      romanized: 'La',
      exampleWordNepali: 'लसुन',
      exampleWordEnglish: 'Garlic',
      emoji: '🧄',

    ),
    NepaliLetter(
      id: 'con_wa',
      letter: 'व',
      romanized: 'Wa',
      exampleWordNepali: 'वन',
      exampleWordEnglish: 'Forest',
      emoji: '🌲',

    ),
    NepaliLetter(
      id: 'con_sha',
      letter: 'श',
      romanized: 'Sha',
      exampleWordNepali: 'शंख',
      exampleWordEnglish: 'Conch Shell',
      emoji: '🐚',

    ),
    NepaliLetter(
      id: 'con_sha2',
      letter: 'ष',
      romanized: 'Sha',
      exampleWordNepali: 'षट्कोण',
      exampleWordEnglish: 'Hexagon',
      emoji: '⬡',

    ),
    NepaliLetter(
      id: 'con_sa',
      letter: 'स',
      romanized: 'Sa',
      exampleWordNepali: 'स्याउ',
      exampleWordEnglish: 'Apple',
      emoji: '🍎',

    ),
    NepaliLetter(
      id: 'con_ha',
      letter: 'ह',
      romanized: 'Ha',
      exampleWordNepali: 'हात्ती',
      exampleWordEnglish: 'Elephant',
      emoji: '🐘',

    ),
    NepaliLetter(
      id: 'con_ksha',
      letter: 'क्ष',
      romanized: 'Ksha',
      exampleWordNepali: 'क्षेत्री',
      exampleWordEnglish: 'Warrior',
      emoji: '⚔️',

    ),
    NepaliLetter(
      id: 'con_tra',
      letter: 'त्र',
      romanized: 'Tra',
      exampleWordNepali: 'त्रिशूल',
      exampleWordEnglish: 'Trident',
      emoji: '🔱',

    ),
    NepaliLetter(
      id: 'con_gya',
      letter: 'ज्ञ',
      romanized: 'Gya',
      exampleWordNepali: 'ज्ञानी',
      exampleWordEnglish: 'Wise',
      emoji: '👼',

    ),
  ];

  // ─── 12 Modifiers (मात्रा र बिन्दुहरू) ─────────────────────────────────────────
  static const List<NepaliLetter> _maatras = [
    NepaliLetter(
      id: 'maatra_aakar',
      letter: '◌ा',
      romanized: 'Aakar',
      exampleWordNepali: 'काग',
      exampleWordEnglish: 'Crow',
      emoji: '🐦',

    ),
    NepaliLetter(
      id: 'maatra_ikar_hraswa',
      letter: '◌ि',
      romanized: 'Hraswa Ikar',
      exampleWordNepali: 'किताब',
      exampleWordEnglish: 'Book',
      emoji: '📖',

    ),
    NepaliLetter(
      id: 'maatra_ikar_deergha',
      letter: '◌ी',
      romanized: 'Deergha Ikar',
      exampleWordNepali: 'कीरा',
      exampleWordEnglish: 'Insect',
      emoji: '🐛',

    ),
    NepaliLetter(
      id: 'maatra_ukar_hraswa',
      letter: '◌ु',
      romanized: 'Hraswa Ukar',
      exampleWordNepali: 'कुकुर',
      exampleWordEnglish: 'Dog',
      emoji: '🐶',

    ),
    NepaliLetter(
      id: 'maatra_ukar_deergha',
      letter: '◌ू',
      romanized: 'Deergha Ukar',
      exampleWordNepali: 'कूचो',
      exampleWordEnglish: 'Broom',
      emoji: '🧹',

    ),
    NepaliLetter(
      id: 'maatra_ekar',
      letter: '◌े',
      romanized: 'Ekar',
      exampleWordNepali: 'केरा',
      exampleWordEnglish: 'Banana',
      emoji: '🍌',

    ),
    NepaliLetter(
      id: 'maatra_aikar',
      letter: '◌ै',
      romanized: 'Aikar',
      exampleWordNepali: 'पैसा',
      exampleWordEnglish: 'Money',
      emoji: '💰',

    ),
    NepaliLetter(
      id: 'maatra_okar',
      letter: '◌ो',
      romanized: 'Okar',
      exampleWordNepali: 'कोइली',
      exampleWordEnglish: 'Cuckoo',
      emoji: '🐦‍⬛',

    ),
    NepaliLetter(
      id: 'maatra_aukar',
      letter: '◌ौ',
      romanized: 'Aukar',
      exampleWordNepali: 'नौका',
      exampleWordEnglish: 'Boat',
      emoji: '⛵',

    ),
    NepaliLetter(
      id: 'maatra_sirbindu',
      letter: '◌ं',
      romanized: 'Sirbindu',
      exampleWordNepali: 'हंस',
      exampleWordEnglish: 'Swan',
      emoji: '🦢',

    ),
    NepaliLetter(
      id: 'maatra_chandrabindu',
      letter: '◌ँ',
      romanized: 'Chandrabindu',
      exampleWordNepali: 'आँखा',
      exampleWordEnglish: 'Eye',
      emoji: '👁️',

    ),
    NepaliLetter(
      id: 'maatra_visarga',
      letter: '◌ः',
      romanized: 'Visarga',
      exampleWordNepali: 'दुःख',
      exampleWordEnglish: 'Sadness',
      emoji: '😢',

    ),
  ];
}
