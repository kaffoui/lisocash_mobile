// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../models/Frais.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DisplayInfos.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';

class FraisDetailsPage extends StatefulWidget {
  Frais frais;
  final bool showAppBar, mayGetOnline, skipLocalData;
  final Function? reloadParentList;

  FraisDetailsPage({
    super.key,
    required this.frais,
    this.showAppBar = false,
    this.mayGetOnline = false,
    this.skipLocalData = false,
    this.reloadParentList,
  });

  @override
  State<FraisDetailsPage> createState() => _FraisDetailsPageState();
}

class _FraisDetailsPageState extends State<FraisDetailsPage> {
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
    // print("Reload Frais in Details Page");
    getFrais(skipLocal: true);
  }

  void getFrais({bool skipLocal = false}) async {
    setState(() {
      isLoading = true;
    });

    await Preferences(skipLocal: skipLocal)
        .getFraisListFromLocal(id: widget.frais.id.toString())
        .then((value) => {
              setState(() async {
                widget.frais = value.single;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                widget.frais = Frais();
                isLoading = false;
              })
            });
  }

  @override
  void initState() {
    if (widget.mayGetOnline == true) getFrais(skipLocal: widget.skipLocalData);
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
                text: "Détails Frais".toUpperCase(),
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
                      title: "Modification Frais",
                      widget: Formulaire(contextFormulaire: context, successCallBack: editCallBack)
                          .saveFraisForm(objectFrais: widget.frais));*/
                },
              ),
              NButtonWidget(
                text: "Supprimer",
                backColor: Colors.red,
                margin: EdgeInsets.all(12),
                rounded: true,
                action: () {
                  /*Formulaire(contextFormulaire: context, successCallBack: deleteCallBack).dialogForDeleteObject(
                    objectToDelete: widget.frais,
                    url: Url.fraisDeleteUrl,
                  );*/
                },
              ),
            ],
          ),
          if (isLoading) Expanded(child: Center(child: NLoadingWidget())),
          if (!isLoading && widget.frais == Frais())
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
                child: Container(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NDisplayInfos(
                        leftIcon: Icons.numbers,
                        title: 'Identifiant',
                        content: "${widget.frais.id}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.transform,
                        title: 'Type operation',
                        content: "${widget.frais.operation_type}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.change_circle_sharp,
                        title: 'Moyen paiement',
                        content: "${widget.frais.moyen_paiement}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.flag_rounded,
                        title: 'Continent',
                        content: "${widget.frais.continent}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.flag_circle_outlined,
                        title: 'Venant de',
                        content: "${widget.frais.from}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.flag_circle_rounded,
                        title: 'A',
                        content: "${widget.frais.to}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.percent,
                        title: 'Pourcentage',
                        content: "${widget.frais.id}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
