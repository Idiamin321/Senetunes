import 'package:flutter/material.dart';
import 'dart:math';

class AnimationRotate extends StatefulWidget {
  final Widget child;
  final bool stop;
  const AnimationRotate({Key? key, required this.child, this.stop = false})
      : super(key: key);

  @override
  _AnimationRotateState createState() => _AnimationRotateState();
}

class _AnimationRotateState extends State<AnimationRotate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant AnimationRotate oldWidget) {
    super.didUpdateWidget(oldWidget);
    // si stop change, on fige l’angle en laissant le controller tourner pour l’AnimatedBuilder
    // (sinon on pourrait aussi pause/resume le controller si tu préfères)
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
      builder: (_, __) {
        double angle = _controller.value * 2 * pi;
        if (widget.stop) {
          angle = 0.0;
        }
        return Transform.rotate(angle: angle, child: widget.child);
      },
    );
  }
}
