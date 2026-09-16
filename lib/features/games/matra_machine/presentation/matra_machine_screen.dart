import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../learning_modules/services/tts_service.dart';
import '../models/matra_combo.dart';

// ─── State ────────────────────────────────────────────────────────────────────
class MatraMachineState {
  final BaseLetterData currentBaseLetter;
  final List<MatraCombo> currentCombos;
  final int currentComboIndex;
  final bool isTransforming;     // Poof animation active
  final String currentResult;    // The currently displayed letter (base or combined)
  final int correctCount;
  final bool isComplete;

  const MatraMachineState({
    required this.currentBaseLetter,
    required this.currentCombos,
    this.currentComboIndex = 0,
    this.isTransforming = false,
    required this.currentResult,
    this.correctCount = 0,
    this.isComplete = false,
  });

  MatraCombo get currentCombo => currentCombos[currentComboIndex];

  MatraMachineState copyWith({
    BaseLetterData? currentBaseLetter,
    List<MatraCombo>? currentCombos,
    int? currentComboIndex,
    bool? isTransforming,
    String? currentResult,
    int? correctCount,
    bool? isComplete,
  }) {
    return MatraMachineState(
      currentBaseLetter: currentBaseLetter ?? this.currentBaseLetter,
      currentCombos: currentCombos ?? this.currentCombos,
      currentComboIndex: currentComboIndex ?? this.currentComboIndex,
      isTransforming: isTransforming ?? this.isTransforming,
      currentResult: currentResult ?? this.currentResult,
      correctCount: correctCount ?? this.correctCount,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────
class MatraMachineNotifier extends Notifier<MatraMachineState> {
  @override
  MatraMachineState build() {
    final base = MatraCombos.getRandomBaseLetter();
    return MatraMachineState(
      currentBaseLetter: base,
      currentCombos: MatraCombos.generateCombos(base),
      currentResult: base.letter,
    );
  }

  void updateState(MatraMachineState newState) {
    state = newState;
  }

  void nextRound() {
    final base = MatraCombos.getRandomBaseLetter();
    state = MatraMachineState(
      currentBaseLetter: base,
      currentCombos: MatraCombos.generateCombos(base),
      currentResult: base.letter,
    );
  }
}

final matraMachineProvider = NotifierProvider<MatraMachineNotifier, MatraMachineState>(
  () => MatraMachineNotifier(),
);

// ─── Screen ───────────────────────────────────────────────────────────────────
class MatraMachineScreen extends ConsumerStatefulWidget {
  const MatraMachineScreen({super.key});

  @override
  ConsumerState<MatraMachineScreen> createState() => _MatraMachineScreenState();
}

class _MatraMachineScreenState extends ConsumerState<MatraMachineScreen>
    with TickerProviderStateMixin {
  late AnimationController _poofController;
  late AnimationController _letterScaleController;
  late Animation<double> _poofAnim;
  late Animation<double> _letterScaleAnim;

  bool _isDraggingOver = false;

  @override
  void initState() {
    super.initState();
    _poofController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _letterScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _poofAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _poofController, curve: Curves.easeOut),
    );
    _letterScaleAnim = Tween<double>(begin: 1, end: 1.4).animate(
      CurvedAnimation(parent: _letterScaleController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _poofController.dispose();
    _letterScaleController.dispose();
    super.dispose();
  }

  void _onMatraDropped(MatraCombo droppedCombo) async {
    final gameState = ref.read(matraMachineProvider);
    final expectedCombo = gameState.currentCombo;

    if (droppedCombo.matraActual != expectedCombo.matraActual) {
      // Wrong matra — shake feedback
      _letterScaleController.forward().then((_) => _letterScaleController.reverse());
      return;
    }

    // Correct! Play poof animation
    ref.read(matraMachineProvider.notifier).updateState(
        gameState.copyWith(isTransforming: true, currentResult: expectedCombo.result));

    _poofController.forward(from: 0);
    _letterScaleController.forward(from: 0).then((_) => _letterScaleController.reverse());

    // Speak the combined letter
    ref.read(ttsServiceProvider).speak(expectedCombo.result);

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final newCount = gameState.correctCount + 1;
    final nextIndex = gameState.currentComboIndex + 1;
    final isComplete = nextIndex >= gameState.currentCombos.length;

    ref.read(matraMachineProvider.notifier).updateState(gameState.copyWith(
      currentComboIndex: isComplete ? 0 : nextIndex,
      isTransforming: false,
      currentResult: gameState.currentBaseLetter.letter,
      correctCount: isComplete ? 0 : newCount,
      isComplete: isComplete,
    ));

    if (isComplete) {
      _showCompleteDialog();
    }
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✨', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            const Text('सबै मात्रा सिकियो!', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.success)),
            const SizedBox(height: 8),
            const Text('All matras learned!', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Icon(Icons.star_rounded, color: Colors.amber, size: 44),
              Icon(Icons.star_rounded, color: Colors.amber, size: 44),
              Icon(Icons.star_rounded, color: Colors.amber, size: 44),
            ]),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(matraMachineProvider.notifier).nextRound();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text('फेरि खेल', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(matraMachineProvider);
    final combo = gameState.currentCombo;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F4FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/games'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)]),
                        child: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('मात्रा मेसिन', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                          Text('Matra Machine', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Instruction ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('👆 ', style: TextStyle(fontSize: 20)),
                      Text(
                        "'${combo.matraDisplay}' लाई तान्नुहोस्",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Drop Target: Center Letter ────────────────────────────────
              DragTarget<MatraCombo>(
                onAcceptWithDetails: (details) {
                  setState(() => _isDraggingOver = false);
                  _onMatraDropped(details.data);
                },
                onWillAcceptWithDetails: (_) {
                  setState(() => _isDraggingOver = true);
                  return true;
                },
                onLeave: (_) => setState(() => _isDraggingOver = false),
                builder: (context, candidateData, rejectedData) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: _isDraggingOver
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: _isDraggingOver ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
                            width: _isDraggingOver ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: _isDraggingOver ? 0.25 : 0.1),
                              blurRadius: _isDraggingOver ? 24 : 12,
                            )
                          ],
                        ),
                        child: ScaleTransition(
                          scale: _letterScaleAnim,
                          child: Center(
                            child: Text(
                              gameState.currentResult,
                              style: const TextStyle(
                                fontSize: 96,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Poof animation overlay
                      if (gameState.isTransforming)
                        AnimatedBuilder(
                          animation: _poofAnim,
                          builder: (_, __) => Opacity(
                            opacity: 1 - _poofAnim.value,
                            child: Transform.scale(
                              scale: 1 + _poofAnim.value * 1.5,
                              child: const Text('✨', style: TextStyle(fontSize: 64)),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 8),
              Text(
                '${combo.matraDisplay}  →  ${combo.result}  (${combo.hint})',
                style: TextStyle(fontSize: 14, color: AppColors.textDark.withValues(alpha: 0.5), fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 32),

              // ── Draggable Matra Bubbles ───────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('मात्राहरू', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: gameState.currentCombos.map((combo) {
                    return Draggable<MatraCombo>(
                      data: combo,
                      feedback: Material(
                        color: Colors.transparent,
                        child: _MatraBubble(combo: combo, isLifted: true),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.35,
                        child: _MatraBubble(combo: combo),
                      ),
                      child: _MatraBubble(combo: combo),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Matra Bubble Widget ──────────────────────────────────────────────────────
class _MatraBubble extends StatelessWidget {
  final MatraCombo combo;
  final bool isLifted;

  const _MatraBubble({required this.combo, this.isLifted = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7E57C2), Color(0xFFB39DDB)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7E57C2).withValues(alpha: isLifted ? 0.6 : 0.3),
            blurRadius: isLifted ? 20 : 8,
            offset: Offset(0, isLifted ? 8 : 3),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              combo.matraDisplay,
              style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
