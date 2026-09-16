/// Represents a single tile on the Memory Match game board.
class MemoryTile {
  final int id;           // Unique position index on the board
  final String pairId;    // Shared ID between the two matching tiles
  final String letter;    // Nepali letter shown when face-up
  final String emoji;     // Emoji shown when face-up
  final String romanized; // Romanized text shown under the letter

  bool isFaceUp;          // Is the tile currently showing its front?
  bool isMatched;         // Has this tile been successfully matched?

  MemoryTile({
    required this.id,
    required this.pairId,
    required this.letter,
    required this.emoji,
    required this.romanized,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  MemoryTile copyWith({
    bool? isFaceUp,
    bool? isMatched,
  }) {
    return MemoryTile(
      id: id,
      pairId: pairId,
      letter: letter,
      emoji: emoji,
      romanized: romanized,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

/// Difficulty levels for the Memory Match game.
enum MatchDifficulty { easy, medium, hard }

extension MatchDifficultyExtension on MatchDifficulty {
  String get label {
    switch (this) {
      case MatchDifficulty.easy:   return 'सजिलो';   // Easy
      case MatchDifficulty.medium: return 'मध्यम';   // Medium
      case MatchDifficulty.hard:   return 'कठिन';    // Hard
    }
  }

  int get pairCount {
    switch (this) {
      case MatchDifficulty.easy:   return 4;
      case MatchDifficulty.medium: return 6;
      case MatchDifficulty.hard:   return 8;
    }
  }

  int get crossAxisCount {
    switch (this) {
      case MatchDifficulty.easy:   return 4;
      case MatchDifficulty.medium: return 4;
      case MatchDifficulty.hard:   return 4;
    }
  }
}
