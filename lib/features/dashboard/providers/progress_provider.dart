import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the global progress state of the user.
class ProgressState {
  final Set<String> viewedLessonIds;
  final Set<String> playedGameIds;
  final Set<String> readStoryIds;

  const ProgressState({
    required this.viewedLessonIds,
    required this.playedGameIds,
    required this.readStoryIds,
  });

  ProgressState copyWith({
    Set<String>? viewedLessonIds,
    Set<String>? playedGameIds,
    Set<String>? readStoryIds,
  }) {
    return ProgressState(
      viewedLessonIds: viewedLessonIds ?? this.viewedLessonIds,
      playedGameIds: playedGameIds ?? this.playedGameIds,
      readStoryIds: readStoryIds ?? this.readStoryIds,
    );
  }
}

/// Notifier to manage progress and sync with SharedPreferences
class ProgressNotifier extends Notifier<ProgressState> {
  static const _lessonsKey = 'viewed_lessons';
  static const _gamesKey = 'played_games';
  static const _storiesKey = 'read_stories';

  @override
  ProgressState build() {
    _loadProgress();
    return const ProgressState(
      viewedLessonIds: {},
      playedGameIds: {},
      readStoryIds: {},
    );
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    final lessonsList = prefs.getStringList(_lessonsKey) ?? [];
    final gamesList = prefs.getStringList(_gamesKey) ?? [];
    final storiesList = prefs.getStringList(_storiesKey) ?? [];

    state = ProgressState(
      viewedLessonIds: lessonsList.toSet(),
      playedGameIds: gamesList.toSet(),
      readStoryIds: storiesList.toSet(),
    );
  }

  Future<void> _saveLessons(Set<String> lessons) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_lessonsKey, lessons.toList());
  }

  Future<void> _saveGames(Set<String> games) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_gamesKey, games.toList());
  }

  Future<void> _saveStories(Set<String> stories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storiesKey, stories.toList());
  }

  /// Marks a specific lesson letter as viewed/read
  Future<void> markLessonAsViewed(String lessonId) async {
    if (!state.viewedLessonIds.contains(lessonId)) {
      final updatedSet = Set<String>.from(state.viewedLessonIds)..add(lessonId);
      
      state = state.copyWith(viewedLessonIds: updatedSet);
      await _saveLessons(updatedSet);
    }
  }

  /// Mark a specific game as played
  Future<void> markGameAsPlayed(String gameId) async {
    if (!state.playedGameIds.contains(gameId)) {
      final updatedSet = Set<String>.from(state.playedGameIds)..add(gameId);
      
      state = state.copyWith(playedGameIds: updatedSet);
      await _saveGames(updatedSet);
    }
  }

  /// Mark a specific story as read
  Future<void> markStoryAsRead(String storyId) async {
    if (!state.readStoryIds.contains(storyId)) {
      final updatedSet = Set<String>.from(state.readStoryIds)..add(storyId);
      
      state = state.copyWith(readStoryIds: updatedSet);
      await _saveStories(updatedSet);
    }
  }
}

/// Global provider for the progress state
final progressProvider = NotifierProvider<ProgressNotifier, ProgressState>(() {
  return ProgressNotifier();
});
