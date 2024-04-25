import 'package:flutter/material.dart';

import 'N_DisplayImageWidget.dart';
import 'N_DisplayTextWidget.dart';

class NIconCardWidget extends StatelessWidget {
  final String iconPath;
  final String? titre;
  final bool useInternetImage;
  final IconData? icon;
  final void Function()? action;
  final Color? borderColor, titleColor, iconColor;

  const NIconCardWidget({
    super.key,
    this.iconPath = "",
    this.titre,
    this.icon,
    this.action,
    this.useInternetImage = false,
    this.borderColor,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: action,
        child: Container(
          padding: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            border: Border.all(
              color: borderColor ?? theme.colorScheme.primary,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    child: iconPath.isNotEmpty
                        ? useInternetImage
                            ? NDisplayImageWidget(
                                imageLink: iconPath,
                                fit: BoxFit.cover,
                                showDefaultImage: true,
                              )
                            : Image.asset(
                                iconPath,
                                color: iconColor!.withOpacity(0.5),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                        : Icon(
                            icon,
                            size: 80,
                            color: iconColor ?? theme.primaryColor,
                          ),
                  ),
                ),
              ),
              Container(
                color: borderColor ?? theme.colorScheme.secondary,
                width: 100,
                height: 2,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: NDisplayTextWidget(
                  text: '${titre!}\n',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  textColor: titleColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NCardServiceIcons extends StatelessWidget {
  final String iconPath, titre;
  final void Function() action;

  const NCardServiceIcons({
    Key? key,
    required this.iconPath,
    required this.titre,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: MaterialStateMouseCursor.clickable,
      child: GestureDetector(
        onTap: action,
        child: Container(
          height: 80,
          width: 70,
          child: Column(
            children: <Widget>[
              Expanded(
                child: NDisplayImageWidget(
                  imageLink: iconPath,
                  showDefaultImage: true,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: NDisplayTextWidget(
                      text: "$titre",
                      textAlign: TextAlign.center,
                      theme: BASE_TEXT_THEME.TITLE,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
