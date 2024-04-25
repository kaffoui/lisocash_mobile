import 'package:flutter/material.dart';

import 'N_DisplayTextWidget.dart';

class NInfosContactWidget extends StatelessWidget {
  final String title;
  final String? content;
  final IconData iconInfos;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Function? onPressed;

  NInfosContactWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.iconInfos,
    this.titleStyle,
    this.contentStyle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (content != null && content!.isNotEmpty)
        ? GestureDetector(
            onTap: () {
              if (onPressed != null) onPressed!();
            },
            child: MouseRegion(
              cursor: onPressed != null ? MaterialStateMouseCursor.clickable : MaterialStateMouseCursor.textable,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        iconInfos,
                        size: Theme.of(context).iconTheme.size,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          NDisplayTextWidget(
                            text: "$title",
                            theme: BASE_TEXT_THEME.LABEL_SMALL,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: NDisplayTextWidget(
                                  text: "$content",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
