import 'package:flutter/material.dart';

import '../constants/fonctions.dart';

class NResponsiveWidget extends StatelessWidget {
  final List<Widget>? autoResponsiveWidgetList;
  final Widget? largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;
  final bool isInLayoutBuilder;
  final Color? backgroundColor;

  const NResponsiveWidget(
      {Key? key,
      required this.largeScreen,
      this.mediumScreen,
      this.smallScreen,
      this.autoResponsiveWidgetList,
      this.isInLayoutBuilder = true,
      this.backgroundColor})
      : super(key: key);

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 991;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 577;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 992 && MediaQuery.of(context).size.width > 576;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: autoResponsiveWidgetList != null
          ? Fonctions().isSmallScreen(context)
              ? GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                  children: autoResponsiveWidgetList!.map((e) => e).toList(),
                  scrollDirection: Axis.vertical,
                )
              : GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  children: autoResponsiveWidgetList!.map((e) => e).toList(),
                )
          : isInLayoutBuilder
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth < 577) {
                      print("In LaySmal");
                      return smallScreen ?? largeScreen!;
                    } else {
                      if (constraints.maxWidth < 992 && constraints.maxWidth > 576) {
                        return mediumScreen ?? largeScreen!;
                      } else {
                        return largeScreen!;
                      }
                    }
                  },
                )
              : Fonctions().isSmallScreen(context)
                  ? smallScreen
                  : Fonctions().isMediumScreen(context)
                      ? mediumScreen ?? largeScreen
                      : largeScreen,
    );
  }
}
