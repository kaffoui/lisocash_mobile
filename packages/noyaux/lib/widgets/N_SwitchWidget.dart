import 'package:flutter/material.dart';

class NSwitchWidget extends StatelessWidget {
  final bool isChecked, showShadow;
  final Color? checkColor, activeColor;
  final void Function(bool value) onChanged;

  const NSwitchWidget({
    super.key,
    required this.isChecked,
    this.showShadow = false,
    required this.onChanged,
    this.checkColor,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.0,
      child: Switch(
        value: isChecked,
        onChanged: onChanged,
        activeTrackColor:
            checkColor ?? Theme.of(context).primaryColor.withOpacity(0.5),
        activeColor: activeColor ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
