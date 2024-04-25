// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../constants/fonctions.dart';
import 'N_ButtonWidget.dart';
import 'N_DisplayTextWidget.dart';
import 'N_MotionAnimationWidget.dart';

class DrawerItem {
  IconData iconData;
  String name;
  String? destinatinLink;
  Widget? page;
  List<DrawerItem>? submenu;
  bool visible, mayShowParentAppBar;
  bool expandedSubMenu;

  DrawerItem({
    required this.iconData,
    required this.name,
    this.page,
    required this.visible,
    this.destinatinLink,
    this.mayShowParentAppBar = true,
    this.submenu,
    this.expandedSubMenu = false,
  });
}

class NMenuWidget extends StatefulWidget {
  Widget? customHeader;
  bool firstIsDropDown, mayShowActiveTrailing;
  List<DrawerItem> itemList;
  int currentIndex;
  double headerHeight;
  IconData? iconActive;
  Color? iconActiveColor, iconNonActiveColor, backColor;
  TextStyle? textStyles;
  EdgeInsetsGeometry? paddingHeader, marginHeader;
  void Function(int currentIndex) onTap;
  void Function(bool currentIndex)? onMenuCollapseChange;
  AppBar? appBar;
  Axis? orientation;
  bool? isCollapsed;

  NMenuWidget({
    Key? key,
    this.appBar,
    this.currentIndex = 0,
    this.customHeader,
    this.firstIsDropDown = false,
    this.headerHeight = 200,
    required this.itemList,
    required this.onTap,
    this.onMenuCollapseChange,
    this.paddingHeader,
    this.marginHeader,
    this.textStyles,
    this.iconActive,
    this.iconActiveColor,
    this.iconNonActiveColor,
    this.backColor,
    this.orientation = Axis.vertical,
    this.isCollapsed = false,
    this.mayShowActiveTrailing = false,
  }) : super(key: key);

  @override
  State<NMenuWidget> createState() => _NMenuWidgetState();
}

class _NMenuWidgetState extends State<NMenuWidget> with SingleTickerProviderStateMixin<NMenuWidget> {
  bool isCollapsed = true, expandPanel = false;
  int _selectedIndex = 0;
  double maxWidth = 250;
  double minWidth = 80;

  late AnimationController _animationController;
  late Animation<double> widthAnimation;

  Widget drawerHeader() {
    return Container(
      height: widget.headerHeight,
      child: widget.customHeader ?? null,
    );
  }

  @override
  void initState() {
    print("MenuColla MyMenu ${widget.isCollapsed}");
    _selectedIndex = widget.currentIndex;
    isCollapsed = widget.isCollapsed ?? false;
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    widget.iconActiveColor = widget.iconActiveColor ?? theme.primaryColor;
    return _buildDrawer();
  }

  Widget _buildDrawer() {
    return AnimatedContainer(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(0, 50), blurRadius: 30)],
      ),
      width: isCollapsed ? minWidth : maxWidth,
      duration: Duration(milliseconds: 300),
      child: Stack(
        children: [
          Container(
            color: widget.backColor,
            child: Column(
              children: [
                drawerHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0),
                    itemCount: widget.itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return drawerItemWidget(
                        item: widget.itemList[index],
                        isActive: index == _selectedIndex,
                        mayShowActiveTrailing: widget.mayShowActiveTrailing,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          widget.itemList[index].destinatinLink != null
                              ? Fonctions().openUrl("${widget.itemList[index].destinatinLink}")
                              : widget.onTap(index);
                        },
                      ) /* _buildMenuList(widget.menuBody[index])*/;
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: -10,
            left: 0,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  NButtonWidget(
                    iconData: isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                    iconColor: Theme.of(context).primaryColor,
                    backColor: Colors.white,
                    showShadow: false,
                    action: () {
                      setState(() {
                        setState(() {
                          isCollapsed = !isCollapsed;
                        });
                        if (widget.onMenuCollapseChange != null) widget.onMenuCollapseChange!(isCollapsed);
                        if (widget.onMenuCollapseChange != null) widget.onMenuCollapseChange!(isCollapsed);
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItemWidget({
    required DrawerItem item,
    bool isActive = false,
    bool mayShowActiveTrailing = false,
    GestureTapCallback? onTap,
  }) {
    return widget.orientation == Axis.horizontal
        ? GestureDetector(
            onTap: () {
              if (onTap != null) onTap();
            },
            child: MouseRegion(
              cursor: MaterialStateMouseCursor.clickable,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        item.iconData,
                        size: 72,
                        color: isActive ? widget.iconActiveColor : widget.iconNonActiveColor ?? Colors.black,
                      ),
                    ),
                    NDisplayTextWidget(
                      text: "${item.name}",
                      selectionColor: isActive ? widget.iconActiveColor : widget.iconNonActiveColor ?? Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          )
        : isCollapsed
            ? GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    item.iconData,
                    size: 24,
                    color: isActive ? widget.iconActiveColor : widget.iconNonActiveColor ?? Colors.black,
                  ),
                ),
              )
            : ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    item.iconData,
                    size: 24,
                    color: isActive ? widget.iconActiveColor : widget.iconNonActiveColor ?? Colors.black,
                  ),
                ),
                title: !isCollapsed
                    ? NDisplayTextWidget(
                        text: "${item.name}",
                        maxLines: 1,
                        textColor: isActive ? widget.iconActiveColor : widget.iconNonActiveColor ?? Colors.black,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: isActive && mayShowActiveTrailing
                    ? NMotionAnimationWidget(
                        delay: 2500,
                        animationdirection: ANIMATIONDIRECTION.LEFTTORIGHT,
                        child: Icon(
                          widget.iconActive ?? Icons.arrow_right,
                          size: 18,
                          color: isActive ? widget.iconActiveColor : widget.iconNonActiveColor ?? Colors.black,
                        ),
                      )
                    : null,
                onTap: onTap,
              );
  }
}
