// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../models/Taux.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';

class TauxDetailsPage extends StatefulWidget {
  Taux taux;
  final bool showAppBar, mayGetOnline, skipLocalData;
  final Function? reloadParentList;

  TauxDetailsPage({
    super.key,
    required this.taux,
    this.showAppBar = false,
    this.mayGetOnline = false,
    this.skipLocalData = false,
    this.reloadParentList,
  });

  @override
  State<TauxDetailsPage> createState() => _TauxDetailsPageState();
}

class _TauxDetailsPageState extends State<TauxDetailsPage> {
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
    // print("Reload Taux in Details Page");
    getTaux(skipLocal: true);
  }

  void getTaux({bool skipLocal = false}) async {
    setState(() {
      isLoading = true;
    });

    await Preferences(skipLocal: skipLocal)
        .getTauxListFromLocal(id: widget.taux.id.toString())
        .then((value) => {
              setState(() async {
                widget.taux = value.single;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                widget.taux = Taux();
                isLoading = false;
              })
            });
  }

  @override
  void initState() {
    if (widget.mayGetOnline == true) getTaux(skipLocal: widget.skipLocalData);
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
                text: "Détails Taux".toUpperCase(),
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
                      title: "Modification Taux",
                      widget: Formulaire(contextFormulaire: context, successCallBack: editCallBack)
                          .saveTauxForm(objectTaux: widget.taux));*/
                },
              ),
              NButtonWidget(
                text: "Supprimer",
                backColor: Colors.red,
                margin: EdgeInsets.all(12),
                rounded: true,
                action: () {
                  /*Formulaire(contextFormulaire: context, successCallBack: deleteCallBack).dialogForDeleteObject(
                    objectToDelete: widget.taux,
                    url: Url.tauxDeleteUrl,
                  );*/
                },
              ),
            ],
          ),
          if (isLoading) Expanded(child: Center(child: NLoadingWidget())),
          if (!isLoading && widget.taux == Taux())
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
                    Container(padding: EdgeInsets.all(8), child: NDisplayTextWidget(text: "id : ${widget.taux.id}")),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
