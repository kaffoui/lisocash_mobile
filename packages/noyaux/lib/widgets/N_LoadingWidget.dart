import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'N_DisplayTextWidget.dart';

class NLoadingWidget extends StatelessWidget {
  final double? width, height, value;
  final Color? color, background, textColor;
  final String? message;

  const NLoadingWidget({
    super.key,
    this.color,
    this.width = 48,
    this.height = 48,
    this.background,
    this.message = "",
    this.textColor,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return message!.isEmpty
        ? Center(
            child: SpinKitCircle(
              size: width!,
              color: color ?? theme.primaryColor,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SpinKitCircle(
                  size: width!,
                  color: color ?? theme.primaryColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: NDisplayTextWidget(
                        text: message!,
                        textColor: textColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              )
            ],
          );
  }
}
