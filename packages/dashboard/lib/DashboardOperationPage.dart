import 'package:flutter/material.dart';
import 'package:noyaux/models/Operation.dart';
import 'package:noyaux/modelsLists/OperationListWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_ResponsiveWidget.dart';

class DashboardOperationPages extends StatefulWidget {
  const DashboardOperationPages({super.key});

  @override
  State<DashboardOperationPages> createState() => _DashboardOperationPagesState();
}

class _DashboardOperationPagesState extends State<DashboardOperationPages> {
  Operation? operation;

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
                    child: _OperationListBloc(
                      onItemPressed: (value) {
                        setState(() {
                          operation = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            smallScreen: _OperationListBloc(showAsGrid: true),
          ),
        ),
      ),
    );
  }

  Widget _OperationListBloc(
      {Key? key, bool showAsGrid = false, Function(Operation operation)? onItemPressed}) {
    return OperationListWidget(
      key: key,
      showItemAsCard: false,
      canEditItem: false,
      canAddItem: false,
      canDeleteItem: true,
      showForAdmin: true,
      message_error: "Aucune transactions effectués",
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
