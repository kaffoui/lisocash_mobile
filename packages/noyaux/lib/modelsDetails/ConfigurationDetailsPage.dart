// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../models/Configuration.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';

class ConfigurationDetailsPage extends StatefulWidget {
  Configuration configuration;
  final bool showAppBar, mayGetOnline, skipLocalData;
  final Function? reloadParentList;

  ConfigurationDetailsPage({
    super.key,
    required this.configuration,
    this.showAppBar = false,
    this.mayGetOnline = false,
    this.skipLocalData = false,
    this.reloadParentList,
  });

  @override
  State<ConfigurationDetailsPage> createState() => _ConfigurationDetailsPageState();
}

class _ConfigurationDetailsPageState extends State<ConfigurationDetailsPage> {
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
    // print("Reload Configuration in Details Page");
    getConfiguration(skipLocal: true);
  }

  void getConfiguration({bool skipLocal = false}) async {
    setState(() {
      isLoading = true;
    });

    await Preferences(skipLocal: skipLocal)
        .getConfigurationListFromLocal(id: widget.configuration.id.toString())
        .then((value) => {
              setState(() async {
                widget.configuration = value.single;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                widget.configuration = Configuration();
                isLoading = false;
              })
            });
  }

  @override
  void initState() {
    if (widget.mayGetOnline == true) getConfiguration(skipLocal: widget.skipLocalData);
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
                text: "Détails Configuration".toUpperCase(),
                textColor: Colors.white,
                theme: BASE_TEXT_THEME.TITLE,
              ),
              centerTitle: true,
            )
          : null,
      body: Column(
        children: [
          Row(
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
                      title: "Modification Configuration",
                      widget: Formulaire(contextFormulaire: context, successCallBack: editCallBack)
                          .saveConfigurationForm(objectConfiguration: widget.configuration));*/
                },
              ),
              NButtonWidget(
                text: "Supprimer",
                backColor: Colors.red,
                margin: EdgeInsets.all(12),
                rounded: true,
                action: () {
                  /*Formulaire(contextFormulaire: context, successCallBack: deleteCallBack).dialogForDeleteObject(
                    objectToDelete: widget.configuration,
                    url: Url.configurationDeleteUrl,
                  );*/
                },
              ),
            ],
          ),
          if (isLoading) Expanded(child: Center(child: NLoadingWidget())),
          if (!isLoading && widget.configuration == Configuration())
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
                    Container(
                        padding: EdgeInsets.all(8), child: NDisplayTextWidget(text: "id : ${widget.configuration.id}")),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
