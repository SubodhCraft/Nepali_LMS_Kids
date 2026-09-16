import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/reward_state.dart';
import '../domain/models/reward_event.dart';

class RewardManager extends Notifier<RewardState> {
  static const _storageKey = 'reward_state';

  @override
  RewardState build() {
    _loadState();
    return RewardState.initial();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      try {
        final jsonMap = jsonDecode(data) as Map<String, dynamic>;
        state = RewardState.fromJson(jsonMap);
      } catch (e) {
        // If parsing fails, stick with initial state
      }
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(state.toJson());
    await prefs.setString(_storageKey, jsonStr);
  }

  /// Dispatches a reward event, calculates the rewards, updates state, and returns the payload.
  Future<RewardPayload> dispatch(RewardEvent event) async {
    int starsToAward = 0;
    String? newSticker;
    String? newBadge;

    switch (event.type) {
      case RewardEventType.lessonComplete:
        // Award effort stars for completing a lesson (tracing a letter, etc.)
        // Non-punitive: Even on retry, they get a star.
        starsToAward = 1;
        break;

      case RewardEventType.storyRead:
        starsToAward = 2;
        // Mock unlocking a sticker if they read a specific story for the first time
        final stickerId = 'sticker_${event.entityId}';
        if (!state.unlockedStickers.contains(stickerId)) {
          newSticker = stickerId;
        }
        break;

      case RewardEventType.gameWin:
        // Games can award 1 to 3 stars based on score/performance
        starsToAward = event.score > 0 ? event.score : 1; 
        break;

      case RewardEventType.streakMaintained:
        starsToAward = 5; // Bonus for streak
        break;
    }

    // Update state
    final updatedStickers = Set<String>.from(state.unlockedStickers);
    if (newSticker != null) updatedStickers.add(newSticker);

    final updatedBadges = Set<String>.from(state.completedMilestones);

    state = state.copyWith(
      totalStars: state.totalStars + starsToAward,
      unlockedStickers: updatedStickers,
      completedMilestones: updatedBadges,
    );

    await _saveState();

    return RewardPayload(
      starsEarned: starsToAward,
      newStickerUnlocked: newSticker,
      newBadgeUnlocked: newBadge,
    );
  }
}

final rewardManagerProvider = NotifierProvider<RewardManager, RewardState>(() {
  return RewardManager();
});
