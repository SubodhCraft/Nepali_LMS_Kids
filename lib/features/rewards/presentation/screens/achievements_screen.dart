import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../rewards/providers/reward_manager.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reward = ref.watch(rewardManagerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                decoration: const BoxDecoration(
                  gradient: AppColors.splashGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/dashboard'),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('🏆', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    const Text(
                      'उपलब्धिहरू',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    const Text(
                      'Your Achievements',
                      style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Stars & Streak Summary ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        emoji: '⭐',
                        value: '${reward.totalStars}',
                        label: 'Total Stars',
                        labelNepali: 'कुल तारा',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        emoji: '🔥',
                        value: '${reward.currentStreak}',
                        label: 'Day Streak',
                        labelNepali: 'दिन लगातार',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF5722), Color(0xFFE64A19)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Milestones Section ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'उपलब्धि मिलस्टोनहरू 🎯',
                  style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _MilestoneRow(
                      emoji: '📚',
                      title: 'पहिलो पाठ',
                      subtitle: 'Complete your first lesson',
                      isUnlocked: reward.totalStars >= 1,
                    ),
                    const SizedBox(height: 10),
                    _MilestoneRow(
                      emoji: '🎮',
                      title: 'खेलाडी',
                      subtitle: 'Win your first game',
                      isUnlocked: reward.totalStars >= 3,
                    ),
                    const SizedBox(height: 10),
                    _MilestoneRow(
                      emoji: '📖',
                      title: 'कथाकार',
                      subtitle: 'Listen to your first story',
                      isUnlocked: reward.totalStars >= 5,
                    ),
                    const SizedBox(height: 10),
                    _MilestoneRow(
                      emoji: '🌟',
                      title: 'सिकारु',
                      subtitle: 'Earn 10 stars total',
                      isUnlocked: reward.totalStars >= 10,
                    ),
                    const SizedBox(height: 10),
                    _MilestoneRow(
                      emoji: '🏅',
                      title: 'मेधावी',
                      subtitle: 'Earn 25 stars total',
                      isUnlocked: reward.totalStars >= 25,
                    ),
                    const SizedBox(height: 10),
                    _MilestoneRow(
                      emoji: '👑',
                      title: 'ज्ञानी',
                      subtitle: 'Earn 50 stars total',
                      isUnlocked: reward.totalStars >= 50,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Sticker Collection ────────────────────────────────────
            if (reward.unlockedStickers.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'स्टिकर संग्रह 🎁',
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: reward.unlockedStickers.map((sticker) {
                    // Derive a friendly emoji from the sticker ID
                    final emojis = ['🐘', '🦁', '🐬', '🦋', '🌈', '🌺', '🎈', '🏵️'];
                    final index = sticker.hashCode.abs() % emojis.length;
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                      ),
                      child: Center(
                        child: Text(emojis[index], style: const TextStyle(fontSize: 32)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final String labelNepali;
  final Gradient gradient;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.labelNepali,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          Text(
            labelNepali,
            style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

// ─── Milestone Row ────────────────────────────────────────────────────────────
class _MilestoneRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isUnlocked;

  const _MilestoneRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.white : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
        boxShadow: isUnlocked
            ? [BoxShadow(color: AppColors.achievements.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 3))]
            : [],
        border: isUnlocked
            ? Border.all(color: AppColors.achievements.withValues(alpha: 0.4), width: 1.5)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Text(
            isUnlocked ? emoji : '🔒',
            style: TextStyle(fontSize: 32, color: isUnlocked ? null : const Color(0xFFBBBBBB)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isUnlocked ? AppColors.textDark : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? AppColors.textDark.withValues(alpha: 0.55) : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.achievements.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Unlocked!',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.achievements),
              ),
            ),
        ],
      ),
    );
  }
}
