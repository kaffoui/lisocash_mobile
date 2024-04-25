import 'package:flutter/material.dart';

class NFadeTransitionWidget extends StatefulWidget {
  final Widget child;
  final int delay, vitesse;
  final double opacityStart, opacityEnd;
  final bool repeat, inReverse, inMillisecond, inMicrosecond, inSecond, endAnimation;

  const NFadeTransitionWidget({
    super.key,
    required this.child,
    this.delay = 3,
    this.vitesse = 2,
    this.opacityStart = 0.3,
    this.opacityEnd = 1.0,
    this.repeat = false,
    this.inReverse = false,
    this.inMillisecond = true,
    this.inMicrosecond = false,
    this.inSecond = false,
    this.endAnimation = false,
  });

  @override
  State<NFadeTransitionWidget> createState() => _NFadeTransitionWidgetState();
}

class _NFadeTransitionWidgetState extends State<NFadeTransitionWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.repeat) {
      _controller = AnimationController(
        duration: widget.inMicrosecond
            ? Duration(microseconds: widget.delay)
            : widget.inMillisecond
                ? Duration(milliseconds: widget.delay)
                : widget.inSecond
                    ? Duration(seconds: widget.delay)
                    : Duration(microseconds: widget.delay),
        vsync: this,
      )..repeat(reverse: widget.inReverse, period: Duration(seconds: widget.vitesse));
    } else {
      _controller = AnimationController(
        duration: widget.inMicrosecond
            ? Duration(microseconds: widget.delay)
            : widget.inMillisecond
                ? Duration(milliseconds: widget.delay)
                : widget.inSecond
                    ? Duration(seconds: widget.delay)
                    : Duration(microseconds: widget.delay),
        vsync: this,
      )..forward();
    }
    _animation = Tween(begin: widget.opacityStart, end: widget.opacityEnd).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    if (_controller.isAnimating || widget.endAnimation) {
      _controller.stop();
      if (_controller.isCompleted || _controller.isDismissed) {
        _controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      alwaysIncludeSemantics: true,
      child: widget.child,
    );
  }
}
