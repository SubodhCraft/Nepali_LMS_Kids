import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/nepali_stories_data.dart';
import '../../domain/models/story.dart';
import '../../../../../core/theme/app_colors.dart';

class StoriesListScreen extends StatelessWidget {
  const StoriesListScreen({super.key});

  Color _hexColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final stories = NepaliStoriesData.stories;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Bar ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/dashboard'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('कथाहरू', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                      Text('Nepali Stories', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Tagline ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.stories.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text('📖 ', style: TextStyle(fontSize: 20)),
                    Expanded(
                      child: Text(
                        'मन पर्ने कथा छान्नुस् र पढ्नुस् वा सुन्नुस्!',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Story Cards ──────────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: stories.length,
                separatorBuilder: (_, i) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final story = stories[i];
                  return _StoryCard(
                    story: story,
                    onTap: () => context.go('/stories/${story.id}'),
                    c1: _hexColor(story.coverColor),
                    c2: _hexColor(story.coverColorEnd),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Story Card ───────────────────────────────────────────────────────────────
class _StoryCard extends StatelessWidget {
  final NepaliStory story;
  final VoidCallback onTap;
  final Color c1;
  final Color c2;

  const _StoryCard({required this.story, required this.onTap, required this.c1, required this.c2});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [c1, c2],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: c1.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Stack(
          children: [
            // Big emoji in the background (decorative)
            Positioned(
              right: -12,
              top: -8,
              child: Text(story.emoji, style: const TextStyle(fontSize: 90)),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    story.titleNepali,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    story.titleEnglish,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          story.description,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          const Icon(Icons.access_time_rounded, color: Colors.white, size: 11),
                          const SizedBox(width: 3),
                          Text('~${story.estimatedMinutes} मिनेट', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
