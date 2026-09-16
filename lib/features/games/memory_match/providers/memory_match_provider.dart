import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/memory_tile.dart';
import '../../../learning_modules/data/nepali_alphabet_data.dart';

// ─── State ────────────────────────────────────────────────────────────────────
class MemoryMatchState {
  final List<MemoryTile> tiles;
  final int? firstSelectedIndex;
  final bool isChecking;   // Locked while flipping back a wrong pair
  final bool isWon;
  final int moves;
  final MatchDifficulty difficulty;

  const MemoryMatchState({
    required this.tiles,
    this.firstSelectedIndex,
    this.isChecking = false,
    this.isWon = false,
    this.moves = 0,
    required this.difficulty,
  });

  MemoryMatchState copyWith({
    List<MemoryTile>? tiles,
    int? firstSelectedIndex,
    bool clearFirst = false,
    bool? isChecking,
    bool? isWon,
    int? moves,
    MatchDifficulty? difficulty,
  }) {
    return MemoryMatchState(
      tiles: tiles ?? this.tiles,
      firstSelectedIndex: clearFirst ? null : (firstSelectedIndex ?? this.firstSelectedIndex),
      isChecking: isChecking ?? this.isChecking,
      isWon: isWon ?? this.isWon,
      moves: moves ?? this.moves,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  int get matchedCount => tiles.where((t) => t.isMatched).length ~/ 2;
  int get totalPairs => difficulty.pairCount;
}

// ─── Notifier ─────────────────────────────────────────────────────────────────
class MemoryMatchNotifier extends Notifier<MemoryMatchState> {
  @override
  MemoryMatchState build() {
    return _buildInitialState(MatchDifficulty.easy);
  }

  static MemoryMatchState _buildInitialState(MatchDifficulty difficulty) {
    return MemoryMatchState(
      tiles: _generateTiles(difficulty),
      difficulty: difficulty,
    );
  }

  static List<MemoryTile> _generateTiles(MatchDifficulty difficulty) {
    // Pull letters from vowels first, then consonants
    final allLetters = [
      ...NepaliAlphabetData.sections.firstWhere((s) => s.id == 'vowels').letters,
      ...NepaliAlphabetData.sections.firstWhere((s) => s.id == 'consonants').letters,
    ];

    final selectedLetters = allLetters.take(difficulty.pairCount).toList();

    // Create pairs
    final List<MemoryTile> tiles = [];
    for (int i = 0; i < selectedLetters.length; i++) {
      final letter = selectedLetters[i];
      // Add two tiles per letter
      tiles.add(MemoryTile(
        id: i * 2,
        pairId: letter.id,
        letter: letter.letter,
        emoji: letter.emoji,
        romanized: letter.romanized,
      ));
      tiles.add(MemoryTile(
        id: i * 2 + 1,
        pairId: letter.id,
        letter: letter.letter,
        emoji: letter.emoji,
        romanized: letter.romanized,
      ));
    }

    // Shuffle
    tiles.shuffle();

    // Reassign ids after shuffle so index matches position
    for (int i = 0; i < tiles.length; i++) {
      tiles[i] = MemoryTile(
        id: i,
        pairId: tiles[i].pairId,
        letter: tiles[i].letter,
        emoji: tiles[i].emoji,
        romanized: tiles[i].romanized,
      );
    }

    return tiles;
  }

  void startGame(MatchDifficulty difficulty) {
    state = MemoryMatchState(
      tiles: _generateTiles(difficulty),
      difficulty: difficulty,
    );
  }

  void restartGame() {
    state = MemoryMatchState(
      tiles: _generateTiles(state.difficulty),
      difficulty: state.difficulty,
    );
  }

  /// Called when the player taps a tile.
  void flipTile(int index) {
    // Ignore taps while in the "checking" animation delay
    if (state.isChecking) return;

    final tile = state.tiles[index];

    // Ignore taps on already matched or already face-up tiles
    if (tile.isMatched || tile.isFaceUp) return;

    final updatedTiles = List<MemoryTile>.from(state.tiles);
    updatedTiles[index] = tile.copyWith(isFaceUp: true);

    // First tile selected
    if (state.firstSelectedIndex == null) {
      state = state.copyWith(
        tiles: updatedTiles,
        firstSelectedIndex: index,
      );
      return;
    }

    // Second tile selected — check for match
    final firstIndex = state.firstSelectedIndex!;
    final firstTile = updatedTiles[firstIndex];
    final moves = state.moves + 1;

    if (firstTile.pairId == tile.pairId) {
      // ✅ MATCH
      updatedTiles[index] = updatedTiles[index].copyWith(isMatched: true);
      updatedTiles[firstIndex] = updatedTiles[firstIndex].copyWith(isMatched: true);

      final isWon = updatedTiles.every((t) => t.isMatched);

      state = state.copyWith(
        tiles: updatedTiles,
        clearFirst: true,
        isChecking: false,
        isWon: isWon,
        moves: moves,
      );
    } else {
      // ❌ NO MATCH — lock board, flip back after 1200ms
      state = state.copyWith(
        tiles: updatedTiles,
        clearFirst: true,
        isChecking: true,
        moves: moves,
      );

      Timer(const Duration(milliseconds: 1200), () {
        final flippedBack = List<MemoryTile>.from(state.tiles);
        flippedBack[index] = flippedBack[index].copyWith(isFaceUp: false);
        flippedBack[firstIndex] = flippedBack[firstIndex].copyWith(isFaceUp: false);
        state = state.copyWith(
          tiles: flippedBack,
          isChecking: false,
        );
      });
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────
final memoryMatchProvider =
    NotifierProvider<MemoryMatchNotifier, MemoryMatchState>(
  () => MemoryMatchNotifier(),
);
