enum RewardEventType {
  lessonComplete,
  storyRead,
  gameWin,
  streakMaintained,
}

class RewardEvent {
  final RewardEventType type;
  final String entityId; // The ID of the lesson, story, or game
  final int score; // Used for games (e.g. stars 1-3 or accuracy)
  final Map<String, dynamic>? metadata;

  const RewardEvent({
    required this.type,
    required this.entityId,
    this.score = 0,
    this.metadata,
  });
}

class RewardPayload {
  final int starsEarned;
  final String? newStickerUnlocked;
  final String? newBadgeUnlocked;
  final bool isStreakMaintained;

  const RewardPayload({
    this.starsEarned = 0,
    this.newStickerUnlocked,
    this.newBadgeUnlocked,
    this.isStreakMaintained = false,
  });
}
