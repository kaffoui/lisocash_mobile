import 'package:app/AppHomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/services/url.dart';

import '../constants/fonctions.dart';
import '../models/Notifications.dart';
import '../models/Operation.dart';
import '../models/Users.dart';
import '../modelsDetails/OperationDetailsPage.dart';
import '../services/Preferences.dart';
import '../services/api/Api.dart';
import '../widgets/N_CardWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_MotionAnimationWidget.dart';
import '../widgets/N_ToastWidget.dart';

class VueOperation extends StatefulWidget {
  final Operation? operation;
  final bool? showAsCard, isSelected;
  final Function? reloadPage, onPressed;
  final Widget? customView;
  final Widget? optionWidget;

  const VueOperation({
    super.key,
    required this.operation,
    this.reloadPage,
    this.showAsCard = false,
    this.isSelected = false,
    this.customView,
    this.optionWidget,
    this.onPressed,
  });

  @override
  State<VueOperation> createState() => _VueOperationState();
}

class _VueOperationState extends State<VueOperation> {
  late ThemeData theme;

  Users? usersConnected;

  void getUsersConnected() async {
    final id = await Preferences().getIdUsers();
    usersConnected = await Preferences().getUsersListFromLocal(id: id).then((value) => value.first);
    setState(() {});
  }

  @override
  void initState() {
    getUsersConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return MouseRegion(
      cursor: MaterialStateMouseCursor.clickable,
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            if (kIsWeb) {
              if (widget.onPressed != null) {
                widget.onPressed!(widget.operation);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OperationDetailsPage(
                      operation: widget.operation!,
                      reloadParentList: widget.reloadPage,
                    ),
                  ),
                );
              }
            } else {
              Fonctions().showWidgetAsModalSheet(
                context: context,
                maxHeight: 520,
                useConstraint: true,
                useSafeArea: true,
                title: "Détails de la transaction",
                trailing: Row(
                  children: [
                    SizedBox(width: 5.0),
                    CircleAvatar(
                      backgroundColor: widget.operation!.isTransfert
                          ? Colors.green
                          : widget.operation!.isRechargement || widget.operation!.isDepot
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.primary,
                      child: Icon(
                        widget.operation!.isTransfert
                            ? MdiIcons.transferUp
                            : widget.operation!.isRechargement || widget.operation!.isDepot
                                ? MdiIcons.transferDown
                                : Icons.info_sharp,
                        color: Colors.white,
                        size: 6.0,
                      ),
                      radius: 6.0,
                    ),
                  ],
                ),
                widget: NCardWidget(
                  elevation: .2,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Type operationn".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${widget.operation?.type_operation}".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Statut".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${widget.operation?.etat_operation}".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Montant envoyer".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${widget.operation?.montant!.split("~")[0]} ${widget.operation?.user_from?.pays?.symbole_monnaie}",
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Montant recu".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${widget.operation?.montant!.split("~")[1]} ${widget.operation?.user_to?.pays?.symbole_monnaie}",
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Frais appliqué".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${widget.operation?.frais?.frais_pourcentage} %",
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Motif".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${widget.operation?.motif}".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Expéditeur".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${widget.operation?.user_from?.nom} ${widget.operation?.user_from?.prenom}",
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Bénéficiaire".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${widget.operation?.user_to?.nom} ${widget.operation?.user_to?.prenom}",
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "Date de transaction".toCapitalizedCase(),
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w700,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: ":",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: NDisplayTextWidget(
                                text: "${Fonctions().displayDate(widget.operation!.date_enregistrement!)}",
                                textAlign: TextAlign.left,
                                fontWeight: FontWeight.w300,
                                theme: BASE_TEXT_THEME.LABEL_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              );
            }
          },
          child: widget.customView ??
              (Fonctions().isLargeScreen(context) || widget.showAsCard == false
                  ? Column(
                      children: [
                        Container(
                          color: widget.isSelected == true ? Colors.grey.shade200 : null,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            width: 56,
                                            height: 56,
                                            child: Icon(
                                              Icons.group_outlined,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: NDisplayTextWidget(
                                                      text: "${widget.operation!.id}",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        // margin: EdgeInsets.only(right: 40),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: NDisplayTextWidget(
                                                text: "${widget.operation!.id}",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        // margin: EdgeInsets.only(right: 40),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: NDisplayTextWidget(
                                                text: "${widget.operation!.id} --> ${widget.operation!.id}",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      width: 44,
                                      height: 44,
                                      child: NMotionAnimationWidget(
                                        key: ValueKey<bool>(widget.isSelected!),
                                        delay: 2500,
                                        animationdirection: ANIMATIONDIRECTION.LEFTTORIGHT,
                                        child: Icon(
                                          Icons.arrow_circle_right,
                                          size: 30,
                                          color: widget.isSelected! ? theme.colorScheme.primary : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : NCardWidget(
                      elevation: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: widget.operation!.isTransfert
                                      ? Colors.green
                                      : widget.operation!.isRechargement || widget.operation!.isDepot
                                          ? theme.colorScheme.secondary
                                          : theme.colorScheme.primary,
                                  child: Icon(
                                    widget.operation!.isTransfert
                                        ? MdiIcons.transferUp
                                        : widget.operation!.isRechargement || widget.operation!.isDepot
                                            ? MdiIcons.transferDown
                                            : Icons.info_sharp,
                                    color: Colors.white,
                                  ),
                                  radius: 16.0,
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.operation!.isTransfert &&
                                          (usersConnected != null && widget.operation!.user_id_from == usersConnected!.id && usersConnected!.isUser))
                                        NDisplayTextWidget(
                                          text:
                                              "Envoie de ${widget.operation!.montant!.split("~")[0]} ${widget.operation!.user_from!.pays!.symbole_monnaie} à ${widget.operation!.user_to!.nom} ${widget.operation!.user_to!.prenom}",
                                          theme: BASE_TEXT_THEME.BODY_SMALL,
                                        ),
                                      if (widget.operation!.isTransfert &&
                                          (usersConnected != null && widget.operation!.user_id_to == usersConnected!.id && usersConnected!.isUser))
                                        NDisplayTextWidget(
                                          text:
                                              "Vous venez de recevoir un montant de ${widget.operation!.montant!.split("~")[0]} ${widget.operation!.user_from!.pays!.symbole_monnaie} de la part de ${widget.operation!.user_from!.nom} ${widget.operation!.user_from!.prenom}",
                                          theme: BASE_TEXT_THEME.BODY_SMALL,
                                        ),
                                      if (widget.operation!.isRechargement)
                                        NDisplayTextWidget(
                                          text:
                                              "Rechargement de ${widget.operation!.montant!.split("~")[0]} ${widget.operation!.user_from!.pays!.symbole_monnaie}",
                                          theme: BASE_TEXT_THEME.BODY_SMALL,
                                        ),
                                      if (widget.operation!.isDepot)
                                        NDisplayTextWidget(
                                          text:
                                              "Envoie de ${widget.operation!.montant!.split("~")[0]} ${widget.operation!.user_from!.pays!.symbole_monnaie} par Lisocash",
                                          theme: BASE_TEXT_THEME.BODY_SMALL,
                                        ),
                                      if (widget.operation!.isRetrait &&
                                          widget.operation!.etat_operation!.toLowerCase() == ETAT_OPERATION.TERMINER.name.toLowerCase())
                                        NDisplayTextWidget(
                                          text:
                                              "Vous venez de retirer un montant ${widget.operation!.montant!.split("~")[0]} ${widget.operation!.user_from!.pays!.symbole_monnaie}",
                                          theme: BASE_TEXT_THEME.BODY_SMALL,
                                        ),
                                      if (widget.operation!.isRetrait &&
                                          widget.operation!.etat_operation!.toLowerCase() == ETAT_OPERATION.EN_COURS.name.toLowerCase())
                                        Row(
                                          children: [
                                            Expanded(
                                              child: NDisplayTextWidget(
                                                text:
                                                    "Un retrait viens d'être lancer d'un montant de ${widget.operation!.montant!.split("~")[0]} ${widget.operation!.user_from!.pays!.symbole_monnaie}",
                                                theme: BASE_TEXT_THEME.BODY_SMALL,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              onPressed: () async {
                                                NToastWidget().showToastStyle(
                                                  context,
                                                  message: "Validation en cours...",
                                                  closeAutomatically: false,
                                                  showActionAsLoad: true,
                                                  alerteetat: ALERTEETAT.AVERTISSEMENT,
                                                );
                                                final oper = widget.operation;
                                                oper!.etat_operation = ETAT_OPERATION.VALIDER.name.toLowerCase();

                                                await Api.saveObjetApi(arguments: oper, url: Url.OperationUrl).then((operSt) async {
                                                  if (operSt["saved"] == true) {
                                                    await Preferences().getUsersListFromLocal(id: usersConnected!.id.toString()).then((userSt) async {
                                                      final user = userSt.first;
                                                      user.solde = "${int.tryParse(user.solde!)! - int.tryParse(oper.montant!)!}";

                                                      Map<String, String> paramsSup = {
                                                        "action": "SAVE",
                                                      };

                                                      await Api.saveObjetApi(
                                                        arguments: user,
                                                        url: Url.UsersUrl,
                                                        additionalArgument: paramsSup,
                                                      ).then((value) async {
                                                        if (value["saved"] == true) {
                                                          final notif = Notifications(
                                                            titre: "Validation de transactions",
                                                            message: "Vous venez de valider votre transactions",
                                                            user_id: user.id,
                                                            type_notification: "validation",
                                                            priorite: "normal",
                                                          );

                                                          await Api.saveObjetApi(
                                                            arguments: notif,
                                                            additionalArgument: {
                                                              'action': 'SAVE',
                                                              'send_notif': '1',
                                                              'fcm_token': '${user.fcm_token}',
                                                            },
                                                            url: Url.NotificationsUrl,
                                                          );

                                                          ScaffoldMessenger.of(context).clearSnackBars();
                                                          NToastWidget().showToastStyle(
                                                            context,
                                                            message: "Validation effectué",
                                                            alerteetat: ALERTEETAT.SUCCES,
                                                          );

                                                          Fonctions().openPageToGo(
                                                            context: context,
                                                            pageToGo: AppHomePage(users: user),
                                                            replacePage: true,
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(context).clearSnackBars();
                                                          NToastWidget().showToastStyle(
                                                            context,
                                                            message: "Une erreur s'est produite",
                                                            alerteetat: ALERTEETAT.ERREUR,
                                                          );
                                                        }
                                                      });
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(context).clearSnackBars();
                                                    NToastWidget().showToastStyle(
                                                      context,
                                                      message: "Une erreur s'est produite",
                                                      alerteetat: ALERTEETAT.ERREUR,
                                                    );
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          NDisplayTextWidget(
                                            text: "${Fonctions().displayDate(widget.operation!.date_envoie!)}",
                                            theme: BASE_TEXT_THEME.LABEL_SMALL,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    ))),
    );
  }
}
