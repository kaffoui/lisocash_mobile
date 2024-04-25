import 'package:flutter/material.dart';

import 'N_DisplayTextWidget.dart';
import 'N_LoadingWidget.dart';
import 'N_MotionAnimationWidget.dart';

enum ALERTEETAT { ATTENTION, INFORMATION, AVERTISSEMENT, ERREUR, SUCCES }

class NToastWidget {
  Future<void> showSimpleToast(
    BuildContext context, {
    ALERTEETAT? alerteetat,
    String? title,
    String message = "",
    Color? titleColor,
    Color? messageColor,
    bool closeAutomatically = true,
  }) async {
    Color initColor;
    IconData initIcon;
    String initTitle;

    switch (alerteetat) {
      case ALERTEETAT.ATTENTION:
        initColor = Colors.deepOrange;
        initTitle = "ATTENTION";
        initIcon = Icons.error;
        break;
      case ALERTEETAT.AVERTISSEMENT:
        initColor = Colors.orange;
        initTitle = "AVERTISSEMENT";
        initIcon = Icons.warning_outlined;
        break;
      case ALERTEETAT.INFORMATION:
        initColor = Colors.orangeAccent;
        initTitle = "INFORMATION";
        initIcon = Icons.info_outlined;
        break;
      case ALERTEETAT.ERREUR:
        initColor = Colors.red;
        initTitle = "ERREUR !";
        initIcon = Icons.close_outlined;
        break;
      case ALERTEETAT.SUCCES:
        initColor = Colors.green;
        initTitle = "SUCCES !";
        initIcon = Icons.close_outlined;
        break;
      default:
        initColor = Theme.of(context).primaryColor;
        initTitle = "$title";
        initIcon = Icons.done;
    }

    final snackBar = SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: closeAutomatically ? Duration(milliseconds: 4000) : Duration(hours: 10),
      content: Card(
        color: initColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 1.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5.0),
              Icon(
                initIcon,
                size: 40.0,
                color: Colors.white,
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NDisplayTextWidget(
                      text: "$initTitle",
                      theme: BASE_TEXT_THEME.TITLE,
                      textColor: titleColor ?? Colors.white,
                    ),
                    NDisplayTextWidget(
                      text: "$message",
                      maxLines: 2,
                      textColor: messageColor ?? Colors.white,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              if (!closeAutomatically)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  height: 35.0,
                  width: 1.0,
                  color: Colors.grey,
                ),
              if (!closeAutomatically)
                SnackBarAction(
                  label: "X",
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                  },
                ),
            ],
          ),
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> showToastStyle(
    BuildContext context, {
    ALERTEETAT? alerteetat,
    String? title,
    String message = "",
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    IconData? icon,
    bool showActionAsLoad = false,
    bool closeAutomatically = true,
  }) async {
    Color initColor;
    IconData initIcon;
    String initTitle;

    switch (alerteetat) {
      case ALERTEETAT.ATTENTION:
        initColor = Colors.deepOrange;
        initTitle = "ATTENTION";
        initIcon = Icons.error;
        break;
      case ALERTEETAT.AVERTISSEMENT:
        initColor = Colors.orange;
        initTitle = "AVERTISSEMENT";
        initIcon = Icons.warning_outlined;
        break;
      case ALERTEETAT.INFORMATION:
        initColor = Colors.orangeAccent;
        initTitle = "INFORMATION";
        initIcon = Icons.info_outlined;
        break;
      case ALERTEETAT.ERREUR:
        initColor = Colors.red;
        initTitle = "ERREUR !";
        initIcon = Icons.close_outlined;
        break;
      case ALERTEETAT.SUCCES:
        initColor = Colors.green;
        initTitle = "SUCCES !";
        initIcon = Icons.close_outlined;
        break;
      default:
        initColor = Theme.of(context).primaryColor;
        initTitle = "$title";
        initIcon = Icons.done;
    }

    final snackBar = SnackBar(
      content: NMotionAnimationWidget(
        delay: 1500,
        animationdirection: ANIMATIONDIRECTION.DOWNTOUP,
        child: Stack(
          children: <Widget>[
            Container(
              width: 320,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: backgroundColor ?? initColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2.0),
                          child: NDisplayTextWidget(
                            text: "$initTitle",
                            textColor: titleColor ?? Colors.white,
                          ),
                        ),
                        Container(
                          child: NDisplayTextWidget(
                            text: "$message",
                            theme: BASE_TEXT_THEME.LABEL_SMALL,
                            textColor: messageColor ?? Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showActionAsLoad)
                    NLoadingWidget(
                      height: 25,
                      width: 25,
                      color: Colors.white,
                    )
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  initIcon,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: closeAutomatically ? Duration(milliseconds: 4000) : Duration(hours: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
