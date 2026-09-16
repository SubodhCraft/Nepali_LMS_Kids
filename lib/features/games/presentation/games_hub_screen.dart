import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class GamesHubScreen extends StatelessWidget {
  const GamesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDF7FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
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
                        Text('खेलहरू', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                        Text('Mini Games', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _GameCard(
                        emoji: '🃏',
                        titleNepali: 'जोडी खेल',
                        titleEnglish: 'Memory Match',
                        description: 'Flip tiles and match the Nepali letters! Great for recognition.',
                        gradientColors: const [Color(0xFF4AA9E8), Color(0xFF26C6DA)],
                        onTap: () => context.go('/games/memory-match'),
                      ),
                      const SizedBox(height: 20),
                      _GameCard(
                        emoji: '✨',
                        titleNepali: 'मात्रा मेसिन',
                        titleEnglish: 'Matra Machine',
                        description: 'Drag a matra onto a letter to make a new sound! Magic!',
                        gradientColors: const [Color(0xFF7E57C2), Color(0xFFB39DDB)],
                        onTap: () => context.go('/games/matra-machine'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String emoji;
  final String titleNepali;
  final String titleEnglish;
  final String description;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _GameCard({
    required this.emoji,
    required this.titleNepali,
    required this.titleEnglish,
    required this.description,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleNepali, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text(titleEnglish, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(description, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85))),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.7), size: 18),
          ],
        ),
      ),
    );
  }
}
