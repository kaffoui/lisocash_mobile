import 'package:flutter/material.dart';

import 'N_DisplayTextWidget.dart';

class NCheckBoxWidget extends StatelessWidget {
  final String valueCheck, title;
  final bool isChecked;
  final void Function(bool? value)? switchChecked;
  final Color? color;

  const NCheckBoxWidget({
    super.key,
    this.valueCheck = "",
    this.title = "",
    this.isChecked = false,
    this.switchChecked,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.grey;
      }
      return color ?? Theme.of(context).primaryColor;
    }

    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: valueCheck != ''
                ? valueCheck == "1"
                    ? true
                    : false
                : isChecked,
            onChanged: switchChecked,
          ),
          SizedBox(width: 8.0),
          if (title.isNotEmpty)
            NDisplayTextWidget(
              text: "$title",
            ),
        ],
      ),
    );
  }
}
