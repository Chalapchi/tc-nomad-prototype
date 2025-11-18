import 'package:flutter/material.dart';

/// Flying Emoji Animation Overlay
/// Displays a flying emoji animation from source to destination
class FlyingEmojiAnimation extends StatefulWidget {
  final String emoji;
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onComplete;

  const FlyingEmojiAnimation({
    super.key,
    required this.emoji,
    required this.startPosition,
    required this.endPosition,
    required this.onComplete,
  });

  @override
  State<FlyingEmojiAnimation> createState() => _FlyingEmojiAnimationState();
}

class _FlyingEmojiAnimationState extends State<FlyingEmojiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Curved path animation
    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Scale animation (grow then shrink)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 0.5)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    // Gentle rotation
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Fade out at the end
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
    ));

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
