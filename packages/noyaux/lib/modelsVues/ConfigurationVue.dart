import 'package:flutter/material.dart';

import '../constants/fonctions.dart';
import '../models/Configuration.dart';
import '../modelsDetails/ConfigurationDetailsPage.dart';
import '../widgets/N_CardWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_MotionAnimationWidget.dart';

class VueConfiguration extends StatefulWidget {
  final Configuration? configuration;
  final bool? showAsCard, isSelected;
  final Function? reloadPage, onPressed;
  final Widget? customView;
  final Widget? optionWidget;

  const VueConfiguration({
    super.key,
    required this.configuration,
    this.reloadPage,
    this.showAsCard = false,
    this.isSelected = false,
    this.customView,
    this.optionWidget,
    this.onPressed,
  });

  @override
  State<VueConfiguration> createState() => _VueConfigurationState();
}

class _VueConfigurationState extends State<VueConfiguration> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: MaterialStateMouseCursor.clickable,
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            if (widget.onPressed != null) {
              widget.onPressed!(widget.configuration);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfigurationDetailsPage(
                    configuration: widget.configuration!,
                    reloadParentList: widget.reloadPage,
                  ),
                ),
              );
            }
          },
          child: widget.customView ??
              (Fonctions().isLargeScreen(context) || widget.showAsCard == false
                  ? Column(
                      children: [
                        Container(
                          color: widget.isSelected == true ? Colors.grey.shade200 : null,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            width: 56,
                                            height: 56,
                                            child: Icon(
                                              Icons.group_outlined,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: NDisplayTextWidget(
                                                      text: "${widget.configuration!.id}",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        // margin: EdgeInsets.only(right: 40),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: NDisplayTextWidget(
                                                text: "${widget.configuration!.id}",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        // margin: EdgeInsets.only(right: 40),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: NDisplayTextWidget(
                                                text: "${widget.configuration!.id} --> ${widget.configuration!.id}",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      width: 44,
                                      height: 44,
                                      child: NMotionAnimationWidget(
                                        key: ValueKey<bool>(widget.isSelected!),
                                        delay: 2500,
                                        animationdirection: ANIMATIONDIRECTION.LEFTTORIGHT,
                                        child: Icon(
                                          Icons.arrow_circle_right,
                                          size: 30,
                                          color: widget.isSelected! ? theme.colorScheme.primary : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : NCardWidget(
                      elevation: 0.1,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(text: "${widget.configuration!.id}"),
                            ),
                            if (widget.optionWidget != null) widget.optionWidget!
                          ],
                        ),
                      ),
                    ))),
    );
  }
}
