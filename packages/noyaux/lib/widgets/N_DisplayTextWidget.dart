// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

enum BASE_TEXT_THEME {
  DISPLAY_LARGE,
  DISPLAY_MEDIUM,
  DISPLAY,
  HEADLINE_LARGE,
  HEADLINE_MEDIUM,
  HEADLINE_SMALL,
  TITLE_LARGE,
  TITLE,
  TITLE_SMALL,
  LABEL_LARGE,
  LABEL_MEDIUM,
  LABEL_SMALL,
  BODY_LARGE,
  BODY,
  BODY_SMALL,
}

TextStyle? renderTextStyle({
  required BuildContext context,
  BASE_TEXT_THEME theme = BASE_TEXT_THEME.BODY,
  Color? textColor,
  FontWeight? fontWeight,
}) {
  TextStyle baseStyle = Theme.of(context).textTheme.bodyMedium!;
  switch (theme) {
    case BASE_TEXT_THEME.DISPLAY_LARGE:
      baseStyle = Theme.of(context).textTheme.displayLarge!;
      break;
    case BASE_TEXT_THEME.DISPLAY_MEDIUM:
      baseStyle = Theme.of(context).textTheme.displayMedium!;
      break;
    case BASE_TEXT_THEME.DISPLAY:
      baseStyle = Theme.of(context).textTheme.displaySmall!;
      break;
    case BASE_TEXT_THEME.HEADLINE_LARGE:
      baseStyle = Theme.of(context).textTheme.headlineLarge!;
      break;
    case BASE_TEXT_THEME.HEADLINE_MEDIUM:
      baseStyle = Theme.of(context).textTheme.headlineMedium!;
      break;
    case BASE_TEXT_THEME.HEADLINE_SMALL:
      baseStyle = Theme.of(context).textTheme.headlineSmall!;
      break;
    case BASE_TEXT_THEME.TITLE_LARGE:
      baseStyle = Theme.of(context).textTheme.titleLarge!;
      break;
    case BASE_TEXT_THEME.TITLE:
      baseStyle = Theme.of(context).textTheme.titleMedium!;
      break;
    case BASE_TEXT_THEME.TITLE_SMALL:
      baseStyle = Theme.of(context).textTheme.titleSmall!;
      break;
    case BASE_TEXT_THEME.LABEL_LARGE:
      baseStyle = Theme.of(context).textTheme.labelLarge!;
      break;
    case BASE_TEXT_THEME.LABEL_MEDIUM:
      baseStyle = Theme.of(context).textTheme.labelMedium!;
      break;
    case BASE_TEXT_THEME.LABEL_SMALL:
      baseStyle = Theme.of(context).textTheme.labelSmall!;
      break;
    case BASE_TEXT_THEME.BODY_LARGE:
      baseStyle = Theme.of(context).textTheme.bodyLarge!;
      break;
    case BASE_TEXT_THEME.BODY:
      baseStyle = Theme.of(context).textTheme.bodyMedium!;
      break;
    case BASE_TEXT_THEME.BODY_SMALL:
      baseStyle = Theme.of(context).textTheme.bodySmall!;
      break;
    default:
      baseStyle = Theme.of(context).textTheme.bodyMedium!;
  }
  return baseStyle.copyWith(color: textColor, fontWeight: fontWeight);
}

class NDisplayTextWidget extends StatelessWidget {
  final BASE_TEXT_THEME? theme;
  final String text;
  final Color? textColor, selectionColor;
  final int? maxLines;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool? softWrap;

  const NDisplayTextWidget({
    super.key,
    required this.text,
    this.theme = BASE_TEXT_THEME.BODY,
    this.textColor,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.overflow,
    this.selectionColor,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: renderTextStyle(context: context, theme: theme!, textColor: textColor, fontWeight: fontWeight),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      selectionColor: selectionColor,
      softWrap: softWrap,
    );
  }
}
