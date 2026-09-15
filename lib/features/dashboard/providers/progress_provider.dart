import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the global progress state of the user.
class ProgressState {
  final Set<String> viewedLessonIds;
  final int gamesPlayed;
  final int storiesRead;

  const ProgressState({
    required this.viewedLessonIds,
    required this.gamesPlayed,
    required this.storiesRead,
  });

  ProgressState copyWith({
    Set<String>? viewedLessonIds,
    int? gamesPlayed,
    int? storiesRead,
  }) {
    return ProgressState(
      viewedLessonIds: viewedLessonIds ?? this.viewedLessonIds,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      storiesRead: storiesRead ?? this.storiesRead,
    );
  }
}

/// Notifier to manage progress and sync with SharedPreferences
class ProgressNotifier extends Notifier<ProgressState> {
  static const _lessonsKey = 'viewed_lessons';
  static const _gamesKey = 'games_played';
  static const _storiesKey = 'stories_read';

  @override
  ProgressState build() {
    _loadProgress();
    return const ProgressState(
      viewedLessonIds: {},
      gamesPlayed: 0,
      storiesRead: 0,
    );
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    final lessonsList = prefs.getStringList(_lessonsKey) ?? [];
    final games = prefs.getInt(_gamesKey) ?? 0;
    final stories = prefs.getInt(_storiesKey) ?? 0;

    state = ProgressState(
      viewedLessonIds: lessonsList.toSet(),
      gamesPlayed: games,
      storiesRead: stories,
    );
  }

  Future<void> _saveLessons(Set<String> lessons) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_lessonsKey, lessons.toList());
  }

  /// Marks a specific lesson letter as viewed/read
  Future<void> markLessonAsViewed(String lessonId) async {
    if (!state.viewedLessonIds.contains(lessonId)) {
      final updatedSet = Set<String>.from(state.viewedLessonIds)..add(lessonId);
      
      state = state.copyWith(viewedLessonIds: updatedSet);
      await _saveLessons(updatedSet);
    }
  }

  /// Mark games as played (stub for future use)
  Future<void> incrementGamesPlayed() async {
    final updated = state.gamesPlayed + 1;
    state = state.copyWith(gamesPlayed: updated);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_gamesKey, updated);
  }

  /// Mark stories as read (stub for future use)
  Future<void> incrementStoriesRead() async {
    final updated = state.storiesRead + 1;
    state = state.copyWith(storiesRead: updated);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storiesKey, updated);
  }
}

/// Global provider for the progress state
final progressProvider = NotifierProvider<ProgressNotifier, ProgressState>(() {
  return ProgressNotifier();
});
