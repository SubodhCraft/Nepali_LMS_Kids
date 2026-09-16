import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import '../../data/nepali_stories_data.dart';
import '../../domain/models/story.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../dashboard/providers/progress_provider.dart';
import '../../../rewards/domain/models/reward_event.dart';
import '../../../rewards/providers/reward_manager.dart';
import '../../../rewards/presentation/widgets/celebration_modal.dart';

// ─── TTS Narration State ──────────────────────────────────────────────────────
enum NarrationStatus { idle, playing, paused }

class StoryNarrationState {
  final NarrationStatus status;
  final int currentSentenceIndex;
  final bool nepaliTtsAvailable;

  const StoryNarrationState({
    this.status = NarrationStatus.idle,
    this.currentSentenceIndex = -1,
    this.nepaliTtsAvailable = true,
  });

  StoryNarrationState copyWith({
    NarrationStatus? status,
    int? currentSentenceIndex,
    bool? nepaliTtsAvailable,
  }) {
    return StoryNarrationState(
      status: status ?? this.status,
      currentSentenceIndex: currentSentenceIndex ?? this.currentSentenceIndex,
      nepaliTtsAvailable: nepaliTtsAvailable ?? this.nepaliTtsAvailable,
    );
  }
}

// ─── Story Reader Screen ──────────────────────────────────────────────────────
class StoryReaderScreen extends ConsumerStatefulWidget {
  final String storyId;
  const StoryReaderScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends ConsumerState<StoryReaderScreen> {
  late final NepaliStory _story;
  final FlutterTts _tts = FlutterTts();

  NarrationStatus _status = NarrationStatus.idle;
  int _currentSentenceIndex = -1;
  bool _nepaliTtsAvailable = true;
  bool _isNarrating = false;

  late List<String> _sentences;
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _sentenceKeys;

  @override
  void initState() {
    super.initState();
    final found = NepaliStoriesData.findById(widget.storyId);
    _story = found ?? NepaliStoriesData.stories.first;
    _sentences = _story.allSentences;
    _sentenceKeys = List.generate(_sentences.length, (_) => GlobalKey());
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      final isAvailable = await _tts.isLanguageAvailable('ne-NP');
      setState(() => _nepaliTtsAvailable = isAvailable is bool && isAvailable);

      if (_nepaliTtsAvailable) {
        await _tts.setLanguage('ne-NP');
      }
      await _tts.setSpeechRate(0.42); // Story pace — a bit slower than letter learning
      await _tts.setPitch(1.05);     // Slightly warm tone
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);

      _tts.setCompletionHandler(() {
        // This fires when each sentence completes
      });
    } catch (e) {
      setState(() => _nepaliTtsAvailable = false);
    }
  }

  Future<void> _startNarration() async {
    if (!_nepaliTtsAvailable) return;
    setState(() {
      _status = NarrationStatus.playing;
      _isNarrating = true;
      _currentSentenceIndex = 0;
    });
    await _narrateFrom(0);
  }

  Future<void> _narrateFrom(int startIndex) async {
    for (int i = startIndex; i < _sentences.length; i++) {
      if (!_isNarrating || _status == NarrationStatus.paused) break;
      setState(() => _currentSentenceIndex = i);
      _scrollToSentence(i);
      await _tts.speak(_sentences[i]);

      // Pause between paragraphs (detect end of paragraph)
      if (_isParagraphBreak(i) && _isNarrating && _status == NarrationStatus.playing) {
        await Future.delayed(const Duration(milliseconds: 600));
      }
    }

    if (_isNarrating && _status == NarrationStatus.playing) {
      // Story finished
      ref.read(progressProvider.notifier).markStoryAsRead(_story.id);
      
      final payload = await ref.read(rewardManagerProvider.notifier).dispatch(
        RewardEvent(type: RewardEventType.storyRead, entityId: _story.id),
      );

      if (mounted) {
        CelebrationModal.show(
          context: context,
          payload: payload,
          onContinue: () {},
        );
      }

      setState(() {
        _status = NarrationStatus.idle;
        _isNarrating = false;
        _currentSentenceIndex = -1;
      });
    }
  }

  bool _isParagraphBreak(int sentenceIndex) {
    int count = 0;
    for (final para in _story.paragraphs) {
      count += para.sentences.length;
      if (sentenceIndex == count - 1) return true;
    }
    return false;
  }

  void _scrollToSentence(int index) {
    final key = _sentenceKeys[index];
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut, alignment: 0.3);
    }
  }

  Future<void> _pauseNarration() async {
    setState(() {
      _status = NarrationStatus.paused;
      _isNarrating = false;
    });
    await _tts.stop();
  }

  Future<void> _resumeNarration() async {
    if (_currentSentenceIndex < 0) {
      await _startNarration();
      return;
    }
    setState(() {
      _status = NarrationStatus.playing;
      _isNarrating = true;
    });
    await _narrateFrom(_currentSentenceIndex);
  }

  Future<void> _stopNarration() async {
    setState(() {
      _status = NarrationStatus.idle;
      _isNarrating = false;
      _currentSentenceIndex = -1;
    });
    await _tts.stop();
  }

  @override
  void dispose() {
    _isNarrating = false;
    _tts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  Color _hexColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final c1 = _hexColor(_story.coverColor);
    final c2 = _hexColor(_story.coverColorEnd);
    final progress = _sentences.isEmpty
        ? 0.0
        : (_currentSentenceIndex < 0 ? 0.0 : (_currentSentenceIndex + 1) / _sentences.length);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient Header ───────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c1, c2]),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () {
                        _stopNarration();
                        context.go('/stories');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(_story.emoji, style: const TextStyle(fontSize: 44)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_story.titleNepali, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                              Text(_story.titleEnglish, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── TTS Warning Banner ────────────────────────────────────────────
          if (!_nepaliTtsAvailable)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE083)),
              ),
              child: Row(
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'अडियो सुन्न उपकरणमा Nepali (ne-NP) voice pack install गर्नुस्।\nSettings → Text-to-Speech → Language',
                      style: TextStyle(fontSize: 12, color: Color(0xFF856404), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

          // ── Story Text ────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: _buildStoryText(),
            ),
          ),
        ],
      ),

      // ── Bottom TTS Controls ────────────────────────────────────────────────
      bottomSheet: _buildTtsControls(c1),
    );
  }

  Widget _buildStoryText() {
    int sentenceCounter = 0;
    final widgets = <Widget>[];

    for (int pi = 0; pi < _story.paragraphs.length; pi++) {
      final para = _story.paragraphs[pi];
      final paraWidgets = <InlineSpan>[];

      for (int si = 0; si < para.sentences.length; si++) {
        final globalIndex = sentenceCounter;
        final isActive = globalIndex == _currentSentenceIndex;
        final isPast = globalIndex < _currentSentenceIndex;

        paraWidgets.add(
          WidgetSpan(
            child: Container(
              key: _sentenceKeys[globalIndex],
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: isActive ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2) : EdgeInsets.zero,
                decoration: isActive
                    ? BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(6),
                      )
                    : null,
                child: Text(
                  para.sentences[si] + (si < para.sentences.length - 1 ? ' ' : ''),
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.9,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? AppColors.textDark
                        : isPast
                            ? AppColors.textDark.withValues(alpha: 0.45)
                            : AppColors.textDark.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
          ),
        );
        sentenceCounter++;
      }

      widgets.add(
        RichText(text: TextSpan(children: paraWidgets)),
      );

      if (pi < _story.paragraphs.length - 1) {
        widgets.add(const SizedBox(height: 24));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildTtsControls(Color accent) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stop
          _ControlButton(
            icon: Icons.stop_rounded,
            color: AppColors.error,
            size: 52,
            onTap: _stopNarration,
          ),
          const SizedBox(width: 24),

          // Play / Pause (main button)
          GestureDetector(
            onTap: () {
              if (_status == NarrationStatus.playing) {
                _pauseNarration();
              } else if (_status == NarrationStatus.paused) {
                _resumeNarration();
              } else {
                _startNarration();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accent, accent.withValues(alpha: 0.7)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: accent.withValues(alpha: 0.45), blurRadius: 16, offset: const Offset(0, 6)),
                ],
              ),
              child: Icon(
                _status == NarrationStatus.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),

          const SizedBox(width: 24),

          // Restart
          _ControlButton(
            icon: Icons.replay_rounded,
            color: AppColors.primary,
            size: 52,
            onTap: () async {
              await _stopNarration();
              await Future.delayed(const Duration(milliseconds: 200));
              _startNarration();
            },
          ),
        ],
      ),
    );
  }
}

// ─── Control Button ───────────────────────────────────────────────────────────
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({required this.icon, required this.color, required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}
