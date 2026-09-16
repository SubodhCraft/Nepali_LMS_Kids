import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/reward_event.dart';

class CelebrationModal extends StatefulWidget {
  final RewardPayload payload;
  final VoidCallback onContinue;

  const CelebrationModal({
    super.key,
    required this.payload,
    required this.onContinue,
  });

  static void show({
    required BuildContext context,
    required RewardPayload payload,
    required VoidCallback onContinue,
  }) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, anim1, anim2) => const SizedBox(),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: CelebrationModal(payload: payload, onContinue: onContinue),
        );
      },
    );
  }

  @override
  State<CelebrationModal> createState() => _CelebrationModalState();
}

class _CelebrationModalState extends State<CelebrationModal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Play celebratory sound here if a sound manager exists
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Particle Burst Background
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ConfettiPainter(animation: _controller),
                ),
              ),
            ),
            
            // The Dialog Content
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text('शाबास!', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.success)),
                    const Text('Well Done!', style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 24),

                    // Stars
                    if (widget.payload.starsEarned > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.payload.starsEarned, (index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.star_rounded, color: Colors.amber, size: 56),
                          );
                        }),
                      ),
                    
                    if (widget.payload.starsEarned > 0) ...[
                      const SizedBox(height: 12),
                      Text('+${widget.payload.starsEarned} Stars', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],

                    // Stickers
                    if (widget.payload.newStickerUnlocked != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.stories.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🎁', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 8),
                            const Text('नयाँ स्टिकर अनलक भयो!', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.stories)),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          widget.onContinue();    // Execute the callback
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 4,
                        ),
                        child: const Text('ठीक छ (Continue)', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Custom Lightweight Confetti Painter ───────────────────────────────────────
class _ConfettiPainter extends CustomPainter {
  final Animation<double> animation;
  final List<_Particle> _particles = [];

  _ConfettiPainter({required this.animation}) : super(repaint: animation) {
    final random = Random();
    // Generate 40 random particles
    for (int i = 0; i < 40; i++) {
      _particles.add(_Particle(
        angle: random.nextDouble() * 2 * pi,
        speed: 2.0 + random.nextDouble() * 6.0,
        color: [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple][random.nextInt(5)],
        size: 6.0 + random.nextDouble() * 8.0,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value == 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in _particles) {
      // Calculate position based on animation value (0 to 1)
      final distance = p.speed * 40 * animation.value;
      final dx = center.dx + cos(p.angle) * distance;
      final dy = center.dy + sin(p.angle) * distance + (animation.value * 100); // add some gravity

      paint.color = p.color.withOpacity((1.0 - animation.value).clamp(0.0, 1.0));
      canvas.drawCircle(Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  final double angle;
  final double speed;
  final Color color;
  final double size;

  _Particle({required this.angle, required this.speed, required this.color, required this.size});
}
