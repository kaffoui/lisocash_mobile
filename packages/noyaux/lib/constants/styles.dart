import 'package:flutter/material.dart';

import 'constants.dart';

class Style {
  static TextStyle defaultTextStyle({
    bool isUrl = false,
    Color? textColor,
    double textSize = Constants.taille,
    FontStyle? textStyle,
    FontWeight? textWeight,
    String? font,
    TextOverflow? textOverflow = TextOverflow.ellipsis,
  }) {
    return TextStyle(
      fontSize: textSize,
      fontStyle: textStyle ?? FontStyle.normal,
      fontWeight: textWeight ?? FontWeight.normal,
      color: textColor ?? Colors.black,
      decoration: isUrl != false ? TextDecoration.underline : null,
      overflow: textOverflow,
      fontFamily: font,
    );
  }
}
