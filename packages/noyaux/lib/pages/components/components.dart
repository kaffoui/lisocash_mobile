import 'package:flutter/material.dart';
import 'package:noyaux/constants/constants.dart';

class MyPainter extends CustomPainter {
  final double radius;
  final List<Color>? color;

  MyPainter(this.radius, [this.color = const [Constants.kPrimaryColor, Constants.kAccentColor]]);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(colors: color!, begin: Alignment.topLeft, end: Alignment.bottomRight)
          .createShader(Rect.fromCircle(
        center: Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyBehavior extends ScrollBehavior {
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
