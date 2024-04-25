import 'package:flutter/material.dart';

import '../constants/styles.dart';
import 'N_LoadingWidget.dart';

class NDisplayInfos extends StatefulWidget {
  final String title;
  final String content;
  final bool isLoading, showAsCard;
  final IconData? leftIcon, rightIcon;
  final EdgeInsetsGeometry? padding, margin;
  final double iconInfosSize;
  final Color? iconInfosColor, titleColor, contentColor;
  final void Function()? onTap;
  final TextStyle? themeTitle, themeContent;

  const NDisplayInfos({
    super.key,
    required this.title,
    this.content = "",
    this.isLoading = false,
    this.showAsCard = false,
    this.leftIcon,
    this.rightIcon,
    this.padding,
    this.margin,
    this.iconInfosSize = 20.0,
    this.iconInfosColor,
    this.titleColor,
    this.contentColor,
    this.onTap,
    this.themeTitle,
    this.themeContent,
  });

  @override
  State<NDisplayInfos> createState() => _NDisplayInfosState();
}

class _NDisplayInfosState extends State<NDisplayInfos> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: widget.margin ?? EdgeInsets.all(.5),
      elevation: widget.showAsCard ? 1 : 0,
      color: widget.showAsCard ? Colors.white : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onHover: (value) {
          setState(() {
            onHover = value;
          });
        },
        onTap: widget.isLoading ? null : widget.onTap,
        child: Container(
          padding: widget.padding ?? EdgeInsets.all(8.0),
          margin: widget.margin,
          child: Row(
            children: <Widget>[
              if (widget.leftIcon != null)
                Container(
                  padding: EdgeInsets.all(16),
                  child: widget.isLoading
                      ? NLoadingWidget(
                          width: 16,
                          height: 16,
                        )
                      : Icon(
                          widget.leftIcon,
                          size: widget.iconInfosSize,
                          color: widget.iconInfosColor ?? theme.primaryColor,
                        ),
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (widget.isLoading)
                      NLoadingWidget(
                        width: 16,
                        height: 16,
                      ),
                    if (!widget.isLoading)
                      Text(
                        "${widget.title}",
                        style: widget.themeTitle ?? Style.defaultTextStyle(textColor: widget.titleColor, textSize: 12.0, textWeight: FontWeight.w300),
                      ),
                    if (!widget.isLoading)
                      if (widget.content.isNotEmpty)
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${widget.content}",
                                style: widget.themeContent ??
                                    Style.defaultTextStyle(
                                      textColor: onHover && widget.onTap != null ? theme.primaryColor : widget.contentColor,
                                      textSize: 14.0,
                                      textWeight: FontWeight.w400,
                                      textOverflow: null,
                                    ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
              if (widget.rightIcon != null)
                Container(
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    widget.rightIcon,
                    size: widget.iconInfosSize,
                    color: widget.iconInfosColor ?? theme.primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
