import 'package:flutter/material.dart';
import 'package:noyaux/models/Frais.dart';
import 'package:noyaux/modelsDetails/FraisDetailsPage.dart';
import 'package:noyaux/modelsLists/FraisListWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_ResponsiveWidget.dart';

class DashboardFraisPages extends StatefulWidget {
  const DashboardFraisPages({super.key});

  @override
  State<DashboardFraisPages> createState() => _DashboardFraisPagesState();
}

class _DashboardFraisPagesState extends State<DashboardFraisPages> {
  Frais? frais;
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
                    child: _FraisListBloc(
                      onItemPressed: (value) {
                        setState(() {
                          frais = value;
                        });
                      },
                    ),
                  ),
                ),
                if (frais != null)
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: NCardWidget(
                            margin: EdgeInsets.zero,
                            child: FraisDetailsPage(
                              key: ValueKey<String>(frais.toString()),
                              frais: frais!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            smallScreen: _FraisListBloc(showAsGrid: true),
          ),
        ),
      ),
    );
  }

  Widget _FraisListBloc({Key? key, bool showAsGrid = false, Function(Frais frais)? onItemPressed}) {
    return FraisListWidget(
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
