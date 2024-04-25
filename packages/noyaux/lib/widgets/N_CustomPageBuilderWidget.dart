import 'package:flutter/material.dart';

enum ANIMATIONDIRECTION { UPTODOWN, DOWNTOUP, RIGHTTOLEFT, LEFTTORIGHT }

class NCustomPageBuilderWidget extends PageRouteBuilder {
  final Widget child;
  final ANIMATIONDIRECTION? direction;

  NCustomPageBuilderWidget({
    required this.child,
    this.direction,
  }) : super(
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation1, animation2) => child,
        );

  Offset getDirection() {
    switch (direction) {
      case ANIMATIONDIRECTION.LEFTTORIGHT:
        return Offset(-1, 0);
      case ANIMATIONDIRECTION.RIGHTTOLEFT:
        return Offset(1, 0);
      case ANIMATIONDIRECTION.UPTODOWN:
        return Offset(0, 1);
      case ANIMATIONDIRECTION.DOWNTOUP:
        return Offset(0, -1);
      default:
        return Offset(0, 0);
    }
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation1, Animation<double> animation2, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: getDirection(),
        end: Offset.zero,
      ).animate(animation1),
      child: child,
    );
  }
}

class NCustomPageFade extends PageRouteBuilder {
  final Widget? page, route;

  NCustomPageFade({this.page, this.route})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(opacity: animation, child: route),
        );
}
