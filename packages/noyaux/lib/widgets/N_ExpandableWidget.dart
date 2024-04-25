import 'package:flutter/material.dart';

import 'N_DisplayTextWidget.dart';

class NExpandableWidget extends StatefulWidget {
  final String? title, content;
  final Widget? child, titleWidget;
  final bool isExpanded;
  final Color? backgroundColor, titleColor, iconColor, contentColor;

  NExpandableWidget({
    super.key,
    this.title,
    this.content = "",
    this.titleWidget,
    this.child,
    this.backgroundColor,
    this.titleColor,
    this.isExpanded = false,
    this.iconColor,
    this.contentColor,
  });

  @override
  State<NExpandableWidget> createState() => _NExpandableWidgetState();
}

class _NExpandableWidgetState extends State<NExpandableWidget> {
  bool isExpanded = false;

  @override
  void initState() {
    isExpanded = widget.isExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      iconColor: widget.iconColor,
      childrenPadding: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: widget.backgroundColor,
      tilePadding: EdgeInsets.only(right: 16),
      shape: Border(bottom: BorderSide(width: 0.1)),
      collapsedBackgroundColor: widget.backgroundColor,
      title: widget.titleWidget ??
          Row(
            children: [
              Container(
                width: 3,
                height: 40,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 12,
              ),
              if (widget.title != null)
                NDisplayTextWidget(
                  text: widget.title!,
                  theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                  textColor: widget.titleColor ?? theme.primaryColor,
                ),
            ],
          ),
      children: [
        widget.child ??
            Row(
              children: [
                NDisplayTextWidget(
                  text: widget.content!,
                  textColor: widget.contentColor,
                ),
              ],
            ),
        SizedBox(height: 8)
      ],
      initiallyExpanded: widget.isExpanded,
    );
  }
}
