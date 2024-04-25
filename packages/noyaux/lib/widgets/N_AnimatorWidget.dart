import 'dart:math';

import 'package:flutter/material.dart';

enum DIRECTIONLOADER { INVERSE, RIGHT }

class NAnimatorWidget extends StatefulWidget {
  final bool startAnimation;
  final Widget child;
  final DIRECTIONLOADER directionloader;

  const NAnimatorWidget({
    super.key,
    this.startAnimation = false,
    required this.child,
    this.directionloader = DIRECTIONLOADER.RIGHT,
  });

  @override
  State<NAnimatorWidget> createState() => _NAnimatorWidgetState();
}

class _NAnimatorWidgetState extends State<NAnimatorWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (animationController.isAnimating) {
      animationController.stop();
      if (animationController.isCompleted || animationController.isDismissed) {
        animationController.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.startAnimation) {
      animationController..repeat();
    } else {
      animationController..stop();
    }

    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: widget.directionloader == DIRECTIONLOADER.RIGHT
              ? animationController.value * 2.0 * pi
              : animationController.value * -2.0 * pi,
          child: child,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
