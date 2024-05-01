// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../models/Operation.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';

class OperationDetailsPage extends StatefulWidget {
  Operation operation;
  final bool showAppBar, mayGetOnline, skipLocalData;
  final Function? reloadParentList;

  OperationDetailsPage({
    super.key,
    required this.operation,
    this.showAppBar = false,
    this.mayGetOnline = false,
    this.skipLocalData = false,
    this.reloadParentList,
  });

  @override
  State<OperationDetailsPage> createState() => _OperationDetailsPageState();
}

class _OperationDetailsPageState extends State<OperationDetailsPage> {
  bool isLoading = false;

  editCallBack() {
    if (widget.reloadParentList != null) {
      widget.reloadParentList!();
    }
    Navigator.pop(context);
  }

  deleteCallBack() {
    if (widget.reloadParentList != null) {
      widget.reloadParentList!();
    }
    Navigator.pop(context);
  }

  void reloadPage() {
    // print("Reload Operation in Details Page");
    getOperation(skipLocal: true);
  }

  void getOperation({bool skipLocal = false}) async {
    setState(() {
      isLoading = true;
    });

    await Preferences(skipLocal: skipLocal)
        .getOperationListFromLocal(id: widget.operation.id.toString())
        .then((value) => {
              setState(() async {
                widget.operation = value.single;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                widget.operation = Operation();
                isLoading = false;
              })
            });
  }

  @override
  void initState() {
    if (widget.mayGetOnline == true) getOperation(skipLocal: widget.skipLocalData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar == true
          ? AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: NDisplayTextWidget(
                text: "Détails Operation".toUpperCase(),
                textColor: Colors.white,
                theme: BASE_TEXT_THEME.TITLE,
              ),
              centerTitle: true,
            )
          : null,
      body: Column(
        children: [
          Visibility(
            visible: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NButtonWidget(
                  text: "Modifier",
                  backColor: Colors.green,
                  isOutline: true,
                  margin: EdgeInsets.all(12),
                  rounded: true,
                  action: () {
                    /*Fonctions().showWidgetAsDialog(
                        context: context,
                        title: "Modification Operation",
                        widget: Formulaire(contextFormulaire: context, successCallBack: editCallBack)
                            .saveOperationForm(objectOperation: widget.operation));*/
                  },
                ),
                NButtonWidget(
                  text: "Supprimer",
                  backColor: Colors.red,
                  margin: EdgeInsets.all(12),
                  rounded: true,
                  action: () {
                    /*Formulaire(contextFormulaire: context, successCallBack: deleteCallBack).dialogForDeleteObject(
                      objectToDelete: widget.operation,
                      url: Url.operationDeleteUrl,
                    );*/
                  },
                ),
              ],
            ),
          ),
          if (isLoading) Expanded(child: Center(child: NLoadingWidget())),
          if (!isLoading && widget.operation == Operation())
            Expanded(
              child: NErrorWidget(
                message: "Aucune donnée trouvée",
                buttonText: "Recharger",
                onPressed: reloadPage,
                isOutline: true,
              ),
            ),
          if (!isLoading)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(padding: EdgeInsets.all(8), child: NDisplayTextWidget(text: "id : ${widget.operation.id}")),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
