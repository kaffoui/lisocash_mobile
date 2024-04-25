import 'package:flutter/material.dart';

import 'N_ButtonWidget.dart';
import 'N_DisplayTextWidget.dart';

class NErrorWidget extends StatelessWidget {
  final String imageLink, message, buttonText;
  final bool isOutline;
  final Color backgroundColor;
  final void Function()? onPressed;

  const NErrorWidget({
    super.key,
    this.imageLink = "assets/images/default_image.png",
    required this.message,
    this.buttonText = "D'accord",
    this.isOutline = false,
    this.backgroundColor = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: backgroundColor,
      padding: EdgeInsets.only(top: 48, bottom: 72, right: 48, left: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Image.asset(
                imageLink,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: NDisplayTextWidget(
              text: "$message",
              textAlign: TextAlign.center,
              theme: BASE_TEXT_THEME.LABEL_SMALL,
            ),
          ),
          if (onPressed != null)
            NButtonWidget(
              text: buttonText,
              action: onPressed,
              isOutline: isOutline,
            ),
        ],
      ),
    );
  }
}
