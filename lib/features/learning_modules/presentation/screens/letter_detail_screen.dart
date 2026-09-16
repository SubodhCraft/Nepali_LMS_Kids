import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/nepali_letter.dart';
import '../../../dashboard/providers/progress_provider.dart';
import '../../../rewards/domain/models/reward_event.dart';
import '../../../rewards/providers/reward_manager.dart';
import '../../../rewards/presentation/widgets/celebration_modal.dart';
import '../widgets/tracing_canvas.dart';
import '../../services/tts_service.dart';

class LetterDetailScreen extends ConsumerStatefulWidget {
  final NepaliLetter letter;
  final List<NepaliLetter> sectionLetters;
  final String sectionId;

  const LetterDetailScreen({
    super.key,
    required this.letter,
    required this.sectionLetters,
    required this.sectionId,
  });

  @override
  ConsumerState<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends ConsumerState<LetterDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnim;
  late Animation<double> _fadeAnim;

  late NepaliLetter _currentLetter;
  late int _currentIndex;
  final GlobalKey<TracingCanvasState> _canvasKey = GlobalKey<TracingCanvasState>();

  @override
  void initState() {
    super.initState();
    _currentLetter = widget.letter;
    _currentIndex = widget.sectionLetters.indexWhere(
      (l) => l.id == widget.letter.id,
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _bounceController.forward();
    _fadeController.forward();
    
    // Track view for initial letter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(progressProvider.notifier).markLessonAsViewed(_currentLetter.id);
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _navigate(int delta) {
    final newIndex = _currentIndex + delta;
    if (newIndex < 0 || newIndex >= widget.sectionLetters.length) return;

    _fadeController.reverse().then((_) {
      setState(() {
        _currentIndex = newIndex;
        _currentLetter = widget.sectionLetters[newIndex];
      });
      // Track view when navigating
      ref.read(progressProvider.notifier).markLessonAsViewed(_currentLetter.id);
      
      _bounceController.reset();
      _bounceController.forward();
      _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasPrev = _currentIndex > 0;
    final hasNext = _currentIndex < widget.sectionLetters.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEBF5FE), Color(0xFFF7FBFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.go('/lessons/section/${widget.sectionId}'),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textDark, size: 20),
                      ),
                    ),
                    Text(
                      '${_currentIndex + 1} / ${widget.sectionLetters.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) / widget.sectionLetters.length,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Main Scrollable Content ───────────────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ── Tracing Canvas ────────────────────────────
                        ScaleTransition(
                          scale: _bounceAnim,
                          child: TracingCanvas(
                            key: _canvasKey,
                            letter: _currentLetter.letter,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Check Tracing Button
                        ElevatedButton.icon(
                          onPressed: _checkTrace,
                          icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
                          label: const Text('Check Trace'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Romanized
                        Text(
                          _currentLetter.romanized,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Example Word Card ──────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Image / Emoji
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: _LetterImage(
                                    imagePath: _currentLetter.imagePath,
                                    emoji: _currentLetter.emoji,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'उदाहरण',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _currentLetter.exampleWordNepali,
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.textDark,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                _currentLetter.exampleWordEnglish,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textDark.withOpacity(0.55),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.volume_up_rounded),
                                            color: AppColors.primary,
                                            iconSize: 28,
                                            onPressed: () {
                                              final textToSpeak =
                                                  "${_currentLetter.letter} बाट ${_currentLetter.exampleWordNepali}";
                                              ref.read(ttsServiceProvider).speak(textToSpeak);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Navigation Buttons ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: hasPrev ? 1.0 : 0.3,
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton.icon(
                          onPressed: hasPrev ? () => _navigate(-1) : null,
                          icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
                          label: const Text('अघिल्लो'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.textDark,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: hasNext ? 1.0 : 0.3,
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton.icon(
                          onPressed: hasNext ? () => _navigate(1) : null,
                          icon: const Text('अर्को'),
                          label: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            elevation: 4,
                            shadowColor: AppColors.primary.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkTrace() {
    final points = _canvasKey.currentState?.currentPoints;
    if (points == null || points.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please trace the letter first!')),
      );
      return;
    }

    final validPoints = points.whereType<Offset>().toList();
    if (validPoints.isEmpty) return;

    double minX = 240, maxX = 0, minY = 240, maxY = 0;
    int outOfBoundsCount = 0;

    for (var p in validPoints) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;

      // Canvas is 240x240. Text is centered.
      // If they draw near the very edges, they are scribbling outside the letter.
      if (p.dx < 30 || p.dx > 210 || p.dy < 30 || p.dy > 210) {
        outOfBoundsCount++;
      }
    }

    double width = maxX - minX;
    double height = maxY - minY;
    
    int score = 10;
    
    // Penalize if the drawing is too small (just a dot or small line)
    if (width < 40 && height < 40) {
      score -= 7;
    } else if (width < 70 || height < 70) {
      score -= 3;
    }
    
    // Penalize heavily for drawing outside the central letter area
    if (outOfBoundsCount > validPoints.length * 0.4) {
      score -= 6; // 40% of drawing is out of bounds
    } else if (outOfBoundsCount > validPoints.length * 0.15) {
      score -= 3; // 15% of drawing is out of bounds
    }

    // Must have drawn enough points
    if (validPoints.length < 20) {
      score -= 3;
    }
    
    if (score < 1) score = 1;
    if (score > 10) score = 10;

    _showEvaluationDialog(score);
  }

  void _showEvaluationDialog(int score) async {
    bool passed = score >= 4;
    
    if (passed) {
      // Dispatch reward for completing a lesson (trace)
      final payload = await ref.read(rewardManagerProvider.notifier).dispatch(
        RewardEvent(
          type: RewardEventType.lessonComplete,
          entityId: widget.letter.id,
        ),
      );

      if (!mounted) return;

      CelebrationModal.show(
        context: context,
        payload: payload,
        onContinue: () {
          // Check if there is a next letter
          final currentIndex = widget.sectionLetters.indexWhere((l) => l.id == widget.letter.id);
          final hasNext = currentIndex < widget.sectionLetters.length - 1;
          
          if (hasNext) {
            _navigate(1);
          } else {
            context.go('/lessons');
          }
        },
      );
    } else {
      // Failed, show retry dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              'Try again!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            content: const Text(
              'You need to trace the letter more accurately. Keep practicing!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _canvasKey.currentState?.clearCanvas();
                },
                child: const Text('OK', style: TextStyle(fontSize: 18)),
              ),
            ],
          );
        },
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Tries to load the image asset; falls back to a large emoji if not found or null.
class _LetterImage extends StatelessWidget {
  final String? imagePath;
  final String emoji;
  const _LetterImage({required this.imagePath, required this.emoji});

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return Center(
        child: Text(emoji, style: const TextStyle(fontSize: 56)),
      );
    }

    return Image.asset(
      imagePath!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Center(
        child: Text(emoji, style: const TextStyle(fontSize: 56)),
      ),
    );
  }
}
