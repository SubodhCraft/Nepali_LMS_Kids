class RewardState {
  final int totalStars;
  final Set<String> unlockedStickers;
  final Set<String> unlockedAvatars;
  final Set<String> completedMilestones;
  final int currentStreak;
  final DateTime? lastActiveDate;

  const RewardState({
    required this.totalStars,
    required this.unlockedStickers,
    required this.unlockedAvatars,
    required this.completedMilestones,
    required this.currentStreak,
    this.lastActiveDate,
  });

  factory RewardState.initial() {
    return const RewardState(
      totalStars: 0,
      unlockedStickers: {},
      unlockedAvatars: {},
      completedMilestones: {},
      currentStreak: 0,
    );
  }

  RewardState copyWith({
    int? totalStars,
    Set<String>? unlockedStickers,
    Set<String>? unlockedAvatars,
    Set<String>? completedMilestones,
    int? currentStreak,
    DateTime? lastActiveDate,
  }) {
    return RewardState(
      totalStars: totalStars ?? this.totalStars,
      unlockedStickers: unlockedStickers ?? this.unlockedStickers,
      unlockedAvatars: unlockedAvatars ?? this.unlockedAvatars,
      completedMilestones: completedMilestones ?? this.completedMilestones,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalStars': totalStars,
      'unlockedStickers': unlockedStickers.toList(),
      'unlockedAvatars': unlockedAvatars.toList(),
      'completedMilestones': completedMilestones.toList(),
      'currentStreak': currentStreak,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
    };
  }

  factory RewardState.fromJson(Map<String, dynamic> json) {
    return RewardState(
      totalStars: json['totalStars'] as int? ?? 0,
      unlockedStickers: (json['unlockedStickers'] as List<dynamic>?)?.cast<String>().toSet() ?? {},
      unlockedAvatars: (json['unlockedAvatars'] as List<dynamic>?)?.cast<String>().toSet() ?? {},
      completedMilestones: (json['completedMilestones'] as List<dynamic>?)?.cast<String>().toSet() ?? {},
      currentStreak: json['currentStreak'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] != null ? DateTime.tryParse(json['lastActiveDate'] as String) : null,
    );
  }
}
