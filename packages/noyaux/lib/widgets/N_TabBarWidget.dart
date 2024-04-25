
import 'package:flutter/material.dart';

import 'N_CardWidget.dart';

class NTabBarItems {
  String titre;
  Widget page;
  IconData? icon;
  bool showPage;

  NTabBarItems({
    required this.titre,
    required this.page,
    this.icon,
    this.showPage = true,
  });
}

class NTabBarWidget extends StatefulWidget {
  final List<NTabBarItems> listItems;
  final Axis direction;
  final double elevation;
  final EdgeInsets paddingView, marginView;
  final int selectedIndex;

  const NTabBarWidget({
    super.key,
    required this.listItems,
    this.selectedIndex = 0,
    this.direction = Axis.horizontal,
    this.elevation = 0.5,
    this.paddingView = const EdgeInsets.all(8.0),
    this.marginView = EdgeInsets.zero,
  });

  @override
  State<NTabBarWidget> createState() => _NTabBarWidgetState();
}

class _NTabBarWidgetState extends State<NTabBarWidget>
    with
        AutomaticKeepAliveClientMixin<NTabBarWidget>,
        TickerProviderStateMixin<NTabBarWidget> {
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    print("lenght: ${widget.listItems.length}");
    _tabController =
        TabController(length: widget.listItems.length, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        selectedIndex = widget.selectedIndex > 0
            ? widget.selectedIndex
            : _tabController!.index;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NCardWidget(
      elevation: widget.elevation,
      child: Container(
        padding: widget.paddingView,
        margin: widget.marginView,
        child: widget.direction == Axis.horizontal
            ? Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: TabBar(
                        controller: _tabController,
                        automaticIndicatorColorAdjustment: true,
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        tabs: widget.listItems
                            .map(
                              (e) => e.showPage
                                  ? Tab(
                                      text: e.titre,
                                      icon:
                                          e.icon != null ? Icon(e.icon) : null,
                                    )
                                  : Tab(),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  Flexible(
                    child: TabBarView(
                      controller: _tabController,
                      children: widget.listItems.map((e) => e.page).toList(),
                    ),
                  ),
                ],
              )
            : Row(
                children: <Widget>[],
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
