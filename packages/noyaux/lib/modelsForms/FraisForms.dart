import 'package:flutter/material.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_DisplayTextWidget.dart';

import '../models/Frais.dart';
import '../services/api/Api.dart';

class FraisForms {
  BuildContext contextFormulaire;
  Function? successCallBack;
  bool? mayPopNavigatorOnSuccess;

  FraisForms(
      {required this.contextFormulaire,
      this.successCallBack,
      this.mayPopNavigatorOnSuccess = true});

  dialogForDeleteObject({
    required var objectToDelete,
    required String url,
    bool isSms = false,
  }) async {
    bool isDelete = false, showYesButton = true;
    String message = "Etes-vous sûre de bien vouloir supprimer cet élément?";
    await showDialog(
      context: contextFormulaire,
      builder: (contextFormulaire) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            title: NDisplayTextWidget(
              text: "Attention".toUpperCase(),
              theme: BASE_TEXT_THEME.LABEL_MEDIUM,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NDisplayTextWidget(
                  text: message,
                ),
                Row(
                  mainAxisAlignment: showYesButton != true
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    if (showYesButton)
                      Expanded(
                        flex: 2,
                        child: NButtonWidget(
                          text: "Oui",
                          backColor: Colors.red,
                          loaderColor: Colors.red,
                          isOutline: true,
                          rounded: true,
                          margin: EdgeInsets.all(12),
                          load: isDelete,
                          action: () async {
                            setState(() {
                              isDelete = true;
                            });
                            Map<String, String> paramsSup = {
                              "action": "DELETE",
                            };
                            await Api.saveObjetApi(
                              arguments: objectToDelete,
                              additionalArgument: paramsSup,
                              url: url,
                            ).then((value) {
                              if (value["saved"] == true) {
                                setState(() {
                                  isDelete = false;
                                  showYesButton = false;
                                  if (successCallBack != null) {
                                    successCallBack!();
                                  } else {
                                    Navigator.pop(contextFormulaire);
                                  }
                                });
                                Navigator.pop(contextFormulaire);
                              } else {
                                setState(() {
                                  isDelete = false;
                                  showYesButton = false;
                                  message = "${value["message_error"]}";
                                });
                              }
                            });
                          },
                        ),
                      ),
                    if (showYesButton) SizedBox(width: 3.0),
                    Expanded(
                      flex: showYesButton != true ? 0 : 2,
                      child: NButtonWidget(
                        text: showYesButton != true ? "D'accord" : "Non",
                        backColor: Colors.green,
                        isOutline: true,
                        margin: EdgeInsets.all(12),
                        rounded: true,
                        action: () {
                          Navigator.pop(contextFormulaire);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget saveFraisForm({Frais? objectFrais}) {
    return Container();
  }
}
