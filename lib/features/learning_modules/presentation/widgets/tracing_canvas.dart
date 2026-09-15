import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TracingCanvas extends StatefulWidget {
  final String letter;

  const TracingCanvas({
    super.key,
    required this.letter,
  });

  @override
  State<TracingCanvas> createState() => TracingCanvasState();
}

class TracingCanvasState extends State<TracingCanvas> {
  List<Offset?> _points = [];

  List<Offset?> get currentPoints => _points;

  void clearCanvas() {
    setState(() {
      _points = [];
    });
  }

  @override
  void didUpdateWidget(TracingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear canvas if letter changes
    if (oldWidget.letter != widget.letter) {
      _points = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 3,
        ),
      ),
      child: Stack(
        children: [
          // Background Letter (Faint Guide)
          Center(
            child: Text(
              widget.letter,
              style: TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.w900,
                color: AppColors.primary.withOpacity(0.12),
                height: 1,
              ),
            ),
          ),
          
          // Drawing Canvas
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  _points = List.from(_points)..add(renderBox.globalToLocal(details.globalPosition));
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  _points = List.from(_points)..add(renderBox.globalToLocal(details.globalPosition));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _points = List.from(_points)..add(null);
                });
              },
              child: CustomPaint(
                painter: _DrawingPainter(_points),
                size: Size.infinite,
              ),
            ),
          ),
          
          // Clear Button
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                iconSize: 28,
                tooltip: 'Clear',
                onPressed: clearCanvas,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return true;
  }
}
