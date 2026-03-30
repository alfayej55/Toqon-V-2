import 'package:car_care/extension/contaxt_extension.dart';
import 'package:flutter/material.dart';

class SnakeBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color snakeHeadColor;
  final Color snakeTailColor;
  final Color snakeTrackColor; // Faint trail color
  final double borderWidth;

  SnakeBorderPainter({
    required this.animation,
    required this.snakeHeadColor,
    required this.snakeTailColor,
    required this.snakeTrackColor,
    required this.borderWidth,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Calculate radius considering the border width
    final radius = (size.width < size.height ? size.width : size.height) / 2 - borderWidth / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Draw the faint track (static)
    final trackPaint = Paint()
      ..color = snakeTrackColor.withValues(alpha: 0.3)
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw the animated snake (head to tail)
    final progress = animation.value;
    const snakeLengthFraction = 0.25;
    const tailLengthFraction = 0.1;

    final totalSnakeAngle = 2 * 3.14159 * snakeLengthFraction;
    final totalTailAngle = 2 * 3.14159 * tailLengthFraction;


    final headStartAngle = (2 * 3.14159) * progress - totalSnakeAngle / 2;

    // --- Draw Tail (Behind Head) ---
    final tailStartAngle = headStartAngle - totalTailAngle;
    final tailEndAngle = headStartAngle;
    final tailSweepAngle = tailEndAngle - tailStartAngle;

    final tailShader = SweepGradient(
      startAngle: tailStartAngle,
      endAngle: tailEndAngle,
      colors: [snakeTailColor.withValues(alpha: 0.0), snakeTailColor], // Fade from transparent to color
      stops: [0.0, 1.0],
    ).createShader(rect);

    final tailPaint = Paint()
      ..shader = tailShader
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      tailStartAngle,
      tailSweepAngle,
      false,
      tailPaint,
    );

    // --- Draw Head (On Top of Tail) ---
    final headEndAngle = headStartAngle + totalSnakeAngle;
    final headSweepAngle = totalSnakeAngle;

    final headShader = SweepGradient(
      startAngle: headStartAngle,
      endAngle: headEndAngle,
      colors: [snakeHeadColor, snakeHeadColor.withValues(alpha: 0.5)],
      stops: [0.0, 1.0],
    ).createShader(rect);

    final headPaint = Paint()
      ..shader = headShader
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      headStartAngle,
      headSweepAngle,
      false,
      headPaint,
    );
  }

  @override
  bool shouldRepaint(SnakeBorderPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value ||
        oldDelegate.snakeHeadColor != snakeHeadColor ||
        oldDelegate.snakeTailColor != snakeTailColor ||
        oldDelegate.snakeTrackColor != snakeTrackColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}


class AnimatedSnakeBorderCard extends StatefulWidget {
  final Widget child;
  final Color snakeHeadColor;
  final Color snakeTailColor;
  final Color snakeTrackColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const AnimatedSnakeBorderCard({
    super.key,
    required this.child,
    this.snakeHeadColor = Colors.red,
    this.snakeTailColor = Colors.blue,
    this.snakeTrackColor = Colors.blueGrey,
    this.borderWidth = 5.0,
    this.borderRadius = 16.0,
    this.margin,
  });

  @override
  State<AnimatedSnakeBorderCard> createState() => _AnimatedSnakeBorderCardState();
}

class _AnimatedSnakeBorderCardState extends State<AnimatedSnakeBorderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Adjust duration for speed (longer = slower)
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0, // Represents a full 360 degree rotation
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Start the animation immediately when the widget is built
    _controller.repeat(); // Use repeat() for continuous animation like ZoSnakeBorder
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Static Card (unchanged)
        widget.child,

        // Animated Snake Border only - Positioned exactly over the card's border
        CustomPaint(
          painter: SnakeBorderPainter(
            animation: _animation,
            snakeHeadColor: widget.snakeHeadColor,
            snakeTailColor: widget.snakeTailColor,
            snakeTrackColor: widget.snakeTrackColor,
            borderWidth: widget.borderWidth,
          ),
          child: Container(
            // Use the same margin passed to the main widget
            margin: widget.margin ?? EdgeInsets.only(bottom: context.screenHeight * 0.014),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              // Only add a base border if desired, the painter handles the animated part
              // border: Border.all(
              //   color: widget.snakeTrackColor.withOpacity(0.1), // Very faint base
              //   width: widget.borderWidth,
              // ),
              color: Colors.transparent, // Crucial for visibility of the static card
            ),
          ),
        ),
      ],
    );
  }
}