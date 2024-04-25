import 'package:flutter/material.dart';
import 'package:noyaux/models/Taux.dart';
import 'package:noyaux/modelsDetails/TauxDetailsPage.dart';
import 'package:noyaux/modelsLists/TauxListWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_ResponsiveWidget.dart';

class DashboardTauxPages extends StatefulWidget {
  const DashboardTauxPages({super.key});

  @override
  State<DashboardTauxPages> createState() => _DashboardTauxPagesState();
}

class _DashboardTauxPagesState extends State<DashboardTauxPages> {
  Taux? taux;
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
                    child: _TauxListBloc(
                      onItemPressed: (value) {
                        setState(() {
                          taux = value;
                        });
                      },
                    ),
                  ),
                ),
                if (taux != null)
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: NCardWidget(
                            margin: EdgeInsets.zero,
                            child: TauxDetailsPage(
                              key: ValueKey<String>(taux.toString()),
                              taux: taux!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            smallScreen: _TauxListBloc(showAsGrid: true),
          ),
        ),
      ),
    );
  }

  Widget _TauxListBloc({Key? key, bool showAsGrid = false, Function(Taux taux)? onItemPressed}) {
    return TauxListWidget(
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
