import 'package:flutter/material.dart';

import 'N_DisplayTextWidget.dart';
import 'N_LoadingWidget.dart';

class NButtonWidget extends StatefulWidget {
  final void Function()? action;
  final String? text;
  final Color? backColor, textColor, iconColor, loaderColor;
  final EdgeInsetsGeometry? padding, margin;
  final double? loaderSize;
  final IconData? iconData;
  final bool load, isOutline, showShadow, rounded;
  final BASE_TEXT_THEME? textTheme;

  const NButtonWidget({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    this.padding,
    this.action,
    this.text = "",
    this.backColor,
    this.textColor,
    this.iconColor,
    this.loaderSize = 10.0,
    this.load = false,
    this.isOutline = false,
    this.showShadow = true,
    this.rounded = true,
    this.iconData,
    this.loaderColor,
    this.textTheme = BASE_TEXT_THEME.LABEL_SMALL,
  });

  @override
  State<NButtonWidget> createState() => _NButtonWidgetState();
}

class _NButtonWidgetState extends State<NButtonWidget> {
  Color? backColor, textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    backColor = widget.backColor ?? theme.colorScheme.primary;
    textColor = !widget.isOutline ? widget.textColor ?? Colors.white : widget.textColor ?? theme.primaryColor;

    return Container(
      padding: widget.margin,
      child: ElevatedButton(
        onPressed: () {
          if (!widget.load) {
            if (widget.action != null) {
              widget.action!();
            }
          }
        },
        child: widget.load == false
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.iconData != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        widget.iconData,
                        size: Theme.of(context).iconTheme.size,
                        color: widget.iconColor ?? textColor,
                      ),
                    ),
                  if (widget.text!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NDisplayTextWidget(
                          text: widget.text!.toUpperCase(),
                          theme: widget.textTheme,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textColor: widget.isOutline == true ? textColor ?? backColor : textColor,
                        ),
                      ],
                    ),
                ],
              )
            : Center(
                child: NLoadingWidget(
                  height: 12,
                  width: 12,
                  color: widget.loaderColor ?? Colors.white,
                ),
              ),
        style: ElevatedButton.styleFrom(
          padding: widget.padding ?? (widget.text!.isNotEmpty ? EdgeInsets.all(12) : EdgeInsets.all(0)),
          shape: widget.rounded
              ? ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: widget.isOutline ? backColor! : Colors.transparent))
              : ContinuousRectangleBorder(side: BorderSide(color: widget.isOutline ? backColor! : Colors.transparent)),
          elevation: widget.showShadow && widget.isOutline == false ? 1 : 0,
          shadowColor: widget.isOutline == true ? Colors.transparent : null,
          alignment: Alignment.center,
          minimumSize: widget.iconData != null && widget.text!.isEmpty ? Size(36, 36) : null,
          backgroundColor: widget.isOutline ? Colors.transparent : backColor,
        ),
      ),
    );
  }
}
