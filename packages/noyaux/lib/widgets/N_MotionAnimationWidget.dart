import 'dart:async';

import 'package:flutter/material.dart';

enum ANIMATIONDIRECTION { UPTODOWN, DOWNTOUP, RIGHTTOLEFT, LEFTTORIGHT }

class NMotionAnimationWidget extends StatefulWidget {
  final Widget child;
  final int delay;
  final bool inMillisecond, inMicrosecond, inSecond, endAnimation;
  final ANIMATIONDIRECTION? animationdirection;

  const NMotionAnimationWidget({
    super.key,
    required this.delay,
    required this.child,
    this.animationdirection,
    this.inMillisecond = false,
    this.inMicrosecond = true,
    this.inSecond = false,
    this.endAnimation = false,
  });

  @override
  State<NMotionAnimationWidget> createState() => _NMotionAnimationWidgetState();
}

class _NMotionAnimationWidgetState extends State<NMotionAnimationWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController animationController;
  late Animation<Offset> animationOffset;

  ANIMATIONDIRECTION? animationdirection;

  void startAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    final curveAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    );
    switch (animationdirection) {
      case ANIMATIONDIRECTION.DOWNTOUP:
        animationOffset = Tween<Offset>(begin: Offset(0.00, 0.50), end: Offset.zero).animate(curveAnimation);
        break;
      case ANIMATIONDIRECTION.UPTODOWN:
        animationOffset = Tween<Offset>(begin: Offset(0.0, -0.50), end: Offset.zero).animate(curveAnimation);
        break;
      case ANIMATIONDIRECTION.LEFTTORIGHT:
        animationOffset = Tween<Offset>(begin: Offset(-0.50, 0.00), end: Offset.zero).animate(curveAnimation);
        break;
      case ANIMATIONDIRECTION.RIGHTTOLEFT:
        animationOffset = Tween<Offset>(begin: Offset(0.50, 0.00), end: Offset.zero).animate(curveAnimation);
        break;
      default:
        animationOffset = Tween<Offset>(begin: Offset(0.0, 0.00), end: Offset.zero).animate(curveAnimation);
    }
    Timer(
        widget.inMicrosecond
            ? Duration(microseconds: widget.delay)
            : widget.inMillisecond
                ? Duration(milliseconds: widget.delay)
                : widget.inSecond
                    ? Duration(seconds: widget.delay)
                    : Duration(microseconds: widget.delay), () {
      animationController.forward();
    });
  }

  @override
  void initState() {
    animationdirection = widget.animationdirection;
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    if (animationController.isAnimating) {
      animationController.stop();
      if (animationController.isCompleted || animationController.isDismissed || widget.endAnimation) {
        animationController.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FadeTransition(
      opacity: animationController,
      child: SlideTransition(
        position: animationOffset,
        child: widget.child,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
