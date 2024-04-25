import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'components.dart';

class MyBodyPage extends StatefulWidget {
  final Widget child;
  final Color backColor;
  const MyBodyPage({super.key, required this.child, this.backColor = Constants.kPrimaryColor});

  @override
  State<MyBodyPage> createState() => _MyBodyPageState();
}

class _MyBodyPageState extends State<MyBodyPage> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;

  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation3 = Tween<double>(begin: .41, end: .38).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Timer(Duration(milliseconds: 2500), () {
      controller1.forward();
    });

    controller2.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: widget.backColor,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: size.height * (animation2.value + .58),
                  left: size.width * .21,
                  child: CustomPaint(
                    painter: MyPainter(
                        50,
                        widget.backColor == Constants.kPrimaryColor
                            ? [Colors.white60, Colors.white]
                            : [Constants.kPrimaryColor, Constants.kAccentColor]),
                  ),
                ),
                Positioned(
                  top: size.height * .98,
                  left: size.width * .1,
                  child: CustomPaint(
                    painter: MyPainter(
                        animation4.value - 30,
                        widget.backColor == Constants.kPrimaryColor
                            ? [Colors.white60, Colors.white]
                            : [Constants.kPrimaryColor, Constants.kAccentColor]),
                  ),
                ),
                Positioned(
                  top: size.height * .5,
                  left: size.width * (animation2.value + .8),
                  child: CustomPaint(
                    painter: MyPainter(
                        30,
                        widget.backColor == Constants.kPrimaryColor
                            ? [Colors.white60, Colors.white]
                            : [Constants.kPrimaryColor, Constants.kAccentColor]),
                  ),
                ),
                Positioned(
                  top: size.height * animation3.value,
                  left: size.width * (animation1.value + .1),
                  child: CustomPaint(
                    painter: MyPainter(
                        60,
                        widget.backColor == Constants.kPrimaryColor
                            ? [Colors.white60, Colors.white]
                            : [Constants.kPrimaryColor, Constants.kAccentColor]),
                  ),
                ),
                Positioned(
                  top: size.height * .1,
                  left: size.width * .8,
                  child: CustomPaint(
                    painter: MyPainter(
                        animation4.value,
                        widget.backColor == Constants.kPrimaryColor
                            ? [Colors.white60, Colors.white]
                            : [Constants.kPrimaryColor, Constants.kAccentColor]),
                  ),
                ),
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
