import 'package:flutter/material.dart';

import '../constants/fonctions.dart';
import '../models/Taux.dart';
import '../modelsDetails/TauxDetailsPage.dart';
import '../widgets/N_CardWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_MotionAnimationWidget.dart';

class VueTaux extends StatefulWidget {
  final Taux? taux;
  final bool? showAsCard, isSelected;
  final Function? reloadPage, onPressed;
  final Widget? customView;
  final Widget? optionWidget;

  const VueTaux({
    super.key,
    required this.taux,
    this.reloadPage,
    this.showAsCard = false,
    this.isSelected = false,
    this.customView,
    this.optionWidget,
    this.onPressed,
  });

  @override
  State<VueTaux> createState() => _VueTauxState();
}

class _VueTauxState extends State<VueTaux> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: WidgetStateMouseCursor.clickable,
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            if (widget.onPressed != null) {
              widget.onPressed!(widget.taux);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TauxDetailsPage(
                    taux: widget.taux!,
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
                                              Icons.change_circle_outlined,
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
                                                      text: "${widget.taux!.id}",
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
                                                text: "${widget.taux!.id}",
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
                                                text: "${widget.taux!.id} --> ${widget.taux!.id}",
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
                                          color: widget.isSelected!
                                              ? theme.colorScheme.primary
                                              : Colors.transparent,
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
                              child: NDisplayTextWidget(text: "${widget.taux!.id}"),
                            ),
                            if (widget.optionWidget != null) widget.optionWidget!
                          ],
                        ),
                      ),
                    ))),
    );
  }
}
