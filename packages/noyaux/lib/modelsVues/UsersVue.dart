import 'package:flutter/material.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/widgets/N_DisplayImageWidget.dart';

import '../constants/fonctions.dart';
import '../models/Users.dart';
import '../modelsDetails/UsersDetailsPage.dart';
import '../widgets/N_CardWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_MotionAnimationWidget.dart';

class VueUsers extends StatefulWidget {
  final Users? users;
  final bool? showAsCard, isSelected;
  final Function? reloadPage, onPressed;
  final Widget? customView;
  final Widget? optionWidget;

  const VueUsers({
    super.key,
    required this.users,
    this.reloadPage,
    this.showAsCard = false,
    this.isSelected = false,
    this.customView,
    this.optionWidget,
    this.onPressed,
  });

  @override
  State<VueUsers> createState() => _VueUsersState();
}

class _VueUsersState extends State<VueUsers> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: WidgetStateMouseCursor.clickable,
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            if (widget.onPressed != null) {
              widget.onPressed!(widget.users);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsersDetailsPage(
                    users: widget.users!,
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
                                            child: NDisplayImageWidget(
                                              size: 36,
                                              isRounded: true,
                                              imageLink: "${widget.users!.lien_pp}",
                                              isUserProfile: true,
                                              fit: BoxFit.cover,
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
                                                      text:
                                                          "${widget.users!.nom} ${widget.users!.prenom}",
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
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: NDisplayTextWidget(
                                                text: "${widget.users!.mail}",
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
                                                text:
                                                    "${widget.users!.code_telephone} ${widget.users!.telephone}",
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
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: 56,
                              height: 56,
                              child: NDisplayImageWidget(
                                size: 36,
                                isRounded: true,
                                imageLink: "${widget.users!.lien_pp}",
                                isUserProfile: true,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${widget.users!.nom} ${widget.users!.prenom}",
                                        style: Style.defaultTextStyle(
                                          textSize: 12.0,
                                          textColor:
                                              widget.users!.isVerifier ? Colors.green : Colors.red,
                                        ),
                                      ),
                                      SizedBox(width: 5.0),
                                      Icon(
                                        widget.users!.isVerifier
                                            ? Icons.check_circle_outline_outlined
                                            : Icons.close,
                                        color: widget.users!.isVerifier ? Colors.green : Colors.red,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${widget.users!.pays!.nom}",
                                        style: Style.defaultTextStyle(textSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (widget.optionWidget != null) widget.optionWidget!
                          ],
                        ),
                      ),
                    ))),
    );
  }
}
