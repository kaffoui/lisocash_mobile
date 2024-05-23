import 'package:flutter/material.dart';
import 'package:noyaux/models/Pays.dart';
import 'package:noyaux/modelsDetails/PaysDetailsPage.dart';
import 'package:noyaux/modelsLists/PaysListWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_ResponsiveWidget.dart';

class DashboardPaysPages extends StatefulWidget {
  const DashboardPaysPages({super.key});

  @override
  State<DashboardPaysPages> createState() => _DashboardPaysPagesState();
}

class _DashboardPaysPagesState extends State<DashboardPaysPages> {
  Pays? pays;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(12),
          child: NResponsiveWidget(
            largeScreen: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: NCardWidget(
                    margin: EdgeInsets.zero,
                    child: _PaysListBloc(
                      onItemPressed: (value) {
                        setState(() {
                          pays = value;
                        });
                      },
                    ),
                  ),
                ),
                if (pays != null)
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: NCardWidget(
                            margin: EdgeInsets.zero,
                            child: PaysDetailsPage(
                              key: ValueKey<String>(pays.toString()),
                              pays: pays!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            smallScreen: _PaysListBloc(showAsGrid: true),
          ),
        ),
      ),
    );
  }

  Widget _PaysListBloc({Key? key, bool showAsGrid = false, Function(Pays pays)? onItemPressed}) {
    return PaysListWidget(
      key: key,
      showItemAsCard: false,
      canEditItem: true,
      canAddItem: true,
      canDeleteItem: true,
      padding: EdgeInsets.all(12),
      showAsGrid: showAsGrid,
      showSearchBar: true,
      onItemPressed: onItemPressed != null
          ? (value) {
              onItemPressed(value);
            }
          : null,
    );
  }
}
