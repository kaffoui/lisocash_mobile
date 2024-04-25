// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../models/Pays.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';

class PaysDetailsPage extends StatefulWidget {
  Pays pays;
  final bool showAppBar, mayGetOnline, skipLocalData;
  final Function? reloadParentList;

  PaysDetailsPage({
    super.key,
    required this.pays,
    this.showAppBar = false,
    this.mayGetOnline = false,
    this.skipLocalData = false,
    this.reloadParentList,
  });

  @override
  State<PaysDetailsPage> createState() => _PaysDetailsPageState();
}

class _PaysDetailsPageState extends State<PaysDetailsPage> {
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
    // print("Reload Pays in Details Page");
    getPays(skipLocal: true);
  }

  void getPays({bool skipLocal = false}) async {
    setState(() {
      isLoading = true;
    });

    await Preferences(skipLocal: skipLocal)
        .getPaysListFromLocal(id: widget.pays.id.toString())
        .then((value) => {
              setState(() async {
                widget.pays = value.single;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                widget.pays = Pays();
                isLoading = false;
              })
            });
  }

  @override
  void initState() {
    if (widget.mayGetOnline == true) getPays(skipLocal: widget.skipLocalData);
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
                text: "Détails Pays".toUpperCase(),
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
                      title: "Modification Pays",
                      widget: Formulaire(contextFormulaire: context, successCallBack: editCallBack)
                          .savePaysForm(objectPays: widget.pays));*/
                },
              ),
              NButtonWidget(
                text: "Supprimer",
                backColor: Colors.red,
                margin: EdgeInsets.all(12),
                rounded: true,
                action: () {
                  /*Formulaire(contextFormulaire: context, successCallBack: deleteCallBack).dialogForDeleteObject(
                    objectToDelete: widget.pays,
                    url: Url.paysDeleteUrl,
                  );*/
                },
              ),
            ],
          ),
          if (isLoading) Expanded(child: Center(child: NLoadingWidget())),
          if (!isLoading && widget.pays == Pays())
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
                    Container(padding: EdgeInsets.all(8), child: NDisplayTextWidget(text: "id : ${widget.pays.id}")),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
