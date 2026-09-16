import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/memory_tile.dart';
import '../../../../../core/theme/app_colors.dart';

/// The beautiful animated tile widget for the Memory Match game.
/// Uses a 3D flip animation via AnimationController + Transform.
class MemoryTileWidget extends StatefulWidget {
  final MemoryTile tile;
  final VoidCallback onTap;
  final int tileIndex; // Used to stagger the back color

  const MemoryTileWidget({
    super.key,
    required this.tile,
    required this.onTap,
    required this.tileIndex,
  });

  @override
  State<MemoryTileWidget> createState() => _MemoryTileWidgetState();
}

class _MemoryTileWidgetState extends State<MemoryTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Track the previous isFaceUp so we can detect changes
  bool _wasFaceUp = false;

  static const List<List<Color>> _tileBackGradients = [
    [Color(0xFF7E57C2), Color(0xFFB39DDB)], // Purple
    [Color(0xFFFF7B54), Color(0xFFFFB347)], // Orange
    [Color(0xFF4AA9E8), Color(0xFF26C6DA)], // Blue
    [Color(0xFF65C878), Color(0xFF81C784)], // Green
    [Color(0xFFEC407A), Color(0xFFF48FB1)], // Pink
    [Color(0xFFFFD45A), Color(0xFFFFE082)], // Yellow
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _wasFaceUp = widget.tile.isFaceUp;
    if (widget.tile.isFaceUp) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(MemoryTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tile.isFaceUp != _wasFaceUp) {
      _wasFaceUp = widget.tile.isFaceUp;
      if (widget.tile.isFaceUp) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> get _backGradient =>
      _tileBackGradients[widget.tileIndex % _tileBackGradients.length];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Mid-flip: switch from back to front face
          final showFront = _animation.value >= 0.5;
          final angle = _animation.value * pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront ? _buildFront() : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _backGradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _backGradient[0].withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    // Mirror the front (since it's mid-flip, it's mirrored)
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.tile.isMatched
              ? AppColors.success.withOpacity(0.15)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.tile.isMatched ? AppColors.success : AppColors.primary.withOpacity(0.25),
            width: widget.tile.isMatched ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.tile.isMatched
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.cardShadow,
              blurRadius: widget.tile.isMatched ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.tile.letter,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: widget.tile.isMatched
                    ? AppColors.success
                    : AppColors.textDark,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.tile.emoji,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
