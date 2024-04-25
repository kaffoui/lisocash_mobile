import 'package:flutter/material.dart';
import 'package:noyaux/models/Configuration.dart';
import 'package:noyaux/modelsDetails/ConfigurationDetailsPage.dart';
import 'package:noyaux/modelsLists/ConfigurationListWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_ResponsiveWidget.dart';

class DashboardConfigurationPages extends StatefulWidget {
  const DashboardConfigurationPages({super.key});

  @override
  State<DashboardConfigurationPages> createState() => _DashboardConfigurationPagesState();
}

class _DashboardConfigurationPagesState extends State<DashboardConfigurationPages> {
  Configuration? configuration;
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
                    child: _ConfigurationListBloc(
                      onItemPressed: (value) {
                        setState(() {
                          configuration = value;
                        });
                      },
                    ),
                  ),
                ),
                if (configuration != null)
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: NCardWidget(
                            margin: EdgeInsets.zero,
                            child: ConfigurationDetailsPage(
                              key: ValueKey<String>(configuration.toString()),
                              configuration: configuration!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            smallScreen: _ConfigurationListBloc(showAsGrid: true),
          ),
        ),
      ),
    );
  }

  Widget _ConfigurationListBloc(
      {Key? key, bool showAsGrid = false, Function(Configuration configuration)? onItemPressed}) {
    return ConfigurationListWidget(
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
