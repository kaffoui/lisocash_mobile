import 'package:flutter/material.dart';

import 'N_ButtonWidget.dart';
import 'N_DisplayTextWidget.dart';

class NInfosBlocWidget extends StatefulWidget {
  final String title;
  final Widget content;
  final bool? showBtnHideContent;

  const NInfosBlocWidget({
    Key? key,
    required this.title,
    required this.content,
    this.showBtnHideContent = true,
  }) : super(key: key);

  @override
  State<NInfosBlocWidget> createState() => _NInfosBlocWidgetState();
}

class _NInfosBlocWidgetState extends State<NInfosBlocWidget> {
  bool hideContent = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Container(
                width: 3,
                height: 40,
                color: Colors.green,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: NDisplayTextWidget(
                    text: widget.title,
                    theme: BASE_TEXT_THEME.TITLE,
                    textColor: Colors.cyan,
                  ),
                ),
              ),
              if (widget.showBtnHideContent == true)
                NButtonWidget(
                  iconData: hideContent == true ? Icons.arrow_circle_down_outlined : Icons.arrow_circle_up_outlined,
                  showShadow: false,
                  backColor: Colors.white,
                  iconColor: Theme.of(context).primaryColor,
                  action: () {
                    hideContent = hideContent == false ? true : false;
                    setState(() {});
                  },
                ),
              if (widget.showBtnHideContent == true)
                SizedBox(
                  width: 8,
                )
            ],
          ),
        ),
        if (hideContent == false)
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: widget.content,
          ),
      ],
    );
  }
}
