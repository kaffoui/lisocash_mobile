import 'package:flutter/material.dart';

class NCardWidget extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor, shadowColor, cardColor;
  final double? elevation;
  final EdgeInsetsGeometry? margin, padding;

  const NCardWidget({
    super.key,
    required this.child,
    this.shadowColor,
    this.borderRadius,
    this.margin,
    this.padding,
    this.borderColor,
    this.cardColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: shadowColor ?? Colors.black87,
      color: cardColor ?? Colors.white,
      elevation: elevation ?? 2,
      clipBehavior: Clip.hardEdge,
      margin: margin ?? EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor ?? Colors.white,
        ),
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(15)),
      ),
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }
}
