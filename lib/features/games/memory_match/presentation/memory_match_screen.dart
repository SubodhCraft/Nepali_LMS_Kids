import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/memory_tile.dart';
import '../providers/memory_match_provider.dart';
import 'widgets/memory_tile_widget.dart';

class MemoryMatchScreen extends ConsumerWidget {
  const MemoryMatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(memoryMatchProvider);

    // Show win overlay when game is won
    if (gameState.isWon) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWinDialog(context, ref, gameState);
      });
    }

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
            children: [
              _buildTopBar(context, ref, gameState),
              _buildDifficultySelector(ref, gameState),
              _buildProgressBar(gameState),
              Expanded(child: _buildGrid(ref, gameState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, WidgetRef ref, MemoryMatchState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.go('/games'),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('जोडी खेल', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                Text('Memory Match', style: TextStyle(fontSize: 12, color: AppColors.textDark.withOpacity(0.5))),
              ],
            ),
          ),
          // Move counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('${state.moves}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Restart
          GestureDetector(
            onTap: () => ref.read(memoryMatchProvider.notifier).restartGame(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
              ),
              child: const Icon(Icons.refresh_rounded, color: AppColors.accent, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector(WidgetRef ref, MemoryMatchState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: MatchDifficulty.values.map((d) {
          final isSelected = state.difficulty == d;
          return GestureDetector(
            onTap: () => ref.read(memoryMatchProvider.notifier).startGame(d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
              child: Text(
                d.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isSelected ? AppColors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProgressBar(MemoryMatchState state) {
    final progress = state.matchedCount / state.totalPairs;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Text(
            '${state.matchedCount}/${state.totalPairs} जोडी',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text('🏆', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildGrid(WidgetRef ref, MemoryMatchState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: state.difficulty.crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: state.tiles.length,
        itemBuilder: (context, index) {
          final tile = state.tiles[index];
          return MemoryTileWidget(
            key: ValueKey('tile_${tile.id}_${tile.pairId}'),
            tile: tile,
            tileIndex: index,
            onTap: () => ref.read(memoryMatchProvider.notifier).flipTile(index),
          );
        },
      ),
    );
  }

  void _showWinDialog(BuildContext context, WidgetRef ref, MemoryMatchState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text(
              'शाबास!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.success),
            ),
            const Text(
              'Well Done!',
              style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star_rounded, color: Colors.amber, size: 44),
                Icon(Icons.star_rounded, color: Colors.amber, size: 44),
                Icon(Icons.star_rounded, color: Colors.amber, size: 44),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${state.moves} चाल मा जितियो!',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(memoryMatchProvider.notifier).restartGame();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('फेरि खेल', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/games');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('ठीक छ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
