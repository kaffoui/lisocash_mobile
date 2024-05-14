import 'dart:convert';

import 'package:app/AppHomePage.dart';
import 'package:app/AppSendMoney.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:noyaux/constants/constants.dart' as cn;
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Currency.dart';
import 'package:noyaux/models/Frais.dart';
import 'package:noyaux/models/Notifications.dart';
import 'package:noyaux/models/Operation.dart';
import 'package:noyaux/models/Pays.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/modelsLists/OperationListWidget.dart';
import 'package:noyaux/modelsVues/OperationVue.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_AnimatorWidget.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_ErrorWidget.dart';
import 'package:noyaux/widgets/N_LoadingWidget.dart';
import 'package:noyaux/widgets/N_TextInputWidget.dart';
import 'package:noyaux/widgets/N_ToastWidget.dart';

import 'AppErrorCritiquePage.dart';
import 'AppScanQrCodePage.dart';

class AppAcceuilPage extends StatefulWidget {
  const AppAcceuilPage({super.key});

  @override
  State<AppAcceuilPage> createState() => _AppAcceuilPageState();
}

class _AppAcceuilPageState extends State<AppAcceuilPage> {
  late ThemeData theme;

  bool getDataUsers = false;

  bool getDataOperations = false;

  bool sendPayment = false;

  Pays? pays_now;

  List<Frais> list_frais = [];

  Currency? currency;

  List<Operation> listOperations = [];

  Users? users;

  void getUsers() async {
    setState(() {
      getDataUsers = true;
    });
    pays_now = await Fonctions().getPaysFromIp();

    String id = await Preferences().getIdUsers();

    if (id.isNotEmpty) {
      users = await Preferences().getUsersListFromLocal(id: id).then((value) => value.first);

      currency = await Api().fetchExchangeRate(users?.pays?.symbole_monnaie, pays_now?.symbole_monnaie);

      getTransactions();
      setState(() {});
    }

    setState(() {
      getDataUsers = false;
    });
  }

  void getTransactions() async {
    setState(() {
      getDataOperations = true;
    });

    final data = await Preferences().getOperationListFromLocal();

    if (data.isNotEmpty) {
      listOperations.clear();
      listOperations.addAll(data
          .where((element) =>
              DateTime.parse(element.date_enregistrement!).day == DateTime.now().day &&
              (element.user_id_from == users!.id || element.user_id_to == users!.id))
          .toList());
      if (listOperations.isNotEmpty) {
        listOperations.sort((a, b) => b.date_enregistrement!.compareTo(a.date_enregistrement!));
      }
    }

    setState(() {
      getDataOperations = false;
    });
  }

  void rechargementCompteLiso() async {
    setState(() {
      sendPayment = true;
    });

    Map<String, dynamic>? paymentIntent;

    String montant = "";
    GlobalKey<FormFieldState> montantKey = GlobalKey<FormFieldState>();

    final pays = await Fonctions().getPaysFromIp();

    List<Frais> _list_frais = [];
    Frais? selectedFrais;

    if (list_frais.isNotEmpty) {
      setState(() {
        _list_frais = list_frais
            .where((element) => element.operation_type!.toLowerCase() == "depot" && element.moyen_paiement!.toLowerCase() == "stripe")
            .toList();
      });
    }
    print("list: $_list_frais");
    if (_list_frais.isNotEmpty) {
      selectedFrais = _list_frais.first;
    }

    if (pays.continent != "Africa") {
      Fonctions().showWidgetAsDialog(
        context: context,
        insetPadding: EdgeInsets.symmetric(horizontal: 12.0),
        onCloseDialog: () {
          setState(() {
            sendPayment = false;
          });
        },
        titleWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                "Rechargement de mon compte",
                style: Style.defaultTextStyle(textSize: 12.0),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: theme.primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        widget: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: 720,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Votre montant doit être supérieur ou égale 5000 ${pays.symbole_monnaie}.",
                          maxLines: 1,
                          style: Style.defaultTextStyle(
                            textSize: 11.0,
                            textOverflow: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                NTextInputWidget(
                  hint: "Montant",
                  validationKey: montantKey,
                  onChanged: (value) {
                    setState(() {
                      montant = value;
                    });
                  },
                  onValidated: (value) {
                    if (value.isNotEmpty && int.parse(value) > 0) {
                      if (int.parse(value) < 5000) {
                        return "Le montant de rechargement doit être supérieur ou égale 5000";
                      }
                    }
                    return null;
                  },
                  rightWidget: Text("${pays.symbole_monnaie}"),
                ),
                if (selectedFrais != null)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: "Des frais ",
                                  style: Style.defaultTextStyle(textSize: 10.0),
                                  children: [
                                    TextSpan(
                                      text: "${selectedFrais.frais_pourcentage} % ",
                                      style: Style.defaultTextStyle(textSize: 10.0, textWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text: "seront appliqués lors de la transaction.",
                                      style: Style.defaultTextStyle(textSize: 10.0),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        if (montant.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Total : ${(int.parse(montant) * double.tryParse(selectedFrais.frais_pourcentage!)!).toStringAsFixed(0)} (${pays.symbole_monnaie})",
                                    textAlign: TextAlign.end,
                                    style: Style.defaultTextStyle(textSize: 10.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                NButtonWidget(
                  text: "Valider",
                  action: () async {
                    if (montantKey.currentState!.validate()) {
                      Navigator.pop(context);

                      final nouveauMontant = (int.parse(montant) * double.tryParse(selectedFrais!.frais_pourcentage!)!).toStringAsFixed(0);

                      try {
                        Map<String, dynamic> body = {
                          "amount": nouveauMontant,
                          "currency": pays.symbole_monnaie,
                        };

                        final response = await http.post(
                          Uri.parse("https://api.stripe.com/v1/payment_intents"),
                          headers: {'Authorization': 'Bearer ${cn.Constants.STRIPE_DEV_SECRET}', 'Content-type': 'application/x-www-form-urlencoded'},
                          body: body,
                        );
                        paymentIntent = jsonDecode(response.body);
                      } catch (e) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        NToastWidget().showToastStyle(
                          context,
                          message: "Une erreur s'est produite..",
                          alerteetat: ALERTEETAT.ERREUR,
                        );
                      }
                      if (paymentIntent != null && paymentIntent!.isNotEmpty) {
                        try {
                          await Stripe.instance.initPaymentSheet(
                            paymentSheetParameters: SetupPaymentSheetParameters(
                              paymentIntentClientSecret: paymentIntent!["client_secret"],
                              style: ThemeMode.system,
                              billingDetails: BillingDetails(
                                email: users!.mail,
                                name: "${users!.nom} ${users!.prenom}",
                                phone: "${users!.code_telephone} ${users!.telephone}",
                                address: Address(
                                  city: "",
                                  country: pays.nom,
                                  line1: "",
                                  line2: "",
                                  postalCode: "",
                                  state: pays.region,
                                ),
                              ),
                              billingDetailsCollectionConfiguration: BillingDetailsCollectionConfiguration(
                                address: AddressCollectionMode.never,
                              ),
                              merchantDisplayName: "LISOCASH",
                            ),
                          );
                        } catch (e) {
                          print("erreur: $e");
                          ScaffoldMessenger.of(context).clearSnackBars();
                          NToastWidget().showToastStyle(
                            context,
                            message: "Une erreur s'est produite..",
                            alerteetat: ALERTEETAT.ERREUR,
                          );
                        }
                      }

                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                        try {
                          await Stripe.instance.presentPaymentSheet().then((value) async {
                            final user = users;
                            final operation = Operation(
                              type_operation: cn.TYPE_OPERATION.RECHARGEMENT.name.toLowerCase(),
                              date_enregistrement: DateTime.now().toString(),
                              date_envoie: DateTime.now().toString(),
                              etat_operation: cn.ETAT_OPERATION.TERMINER.name.toLowerCase(),
                              montant: "$nouveauMontant~$montant",
                              frais_id: selectedFrais!.id,
                              motif: "Dépôt sur mon compte",
                              taux_id: 0,
                              user_id_from: user!.id,
                              user_id_to: 1,
                              date_reception: DateTime.now().toString(),
                              id: 0,
                            );

                            await Api.saveObjetApi(
                              arguments: operation,
                              url: Url.OperationUrl,
                              additionalArgument: {"action": "SAVE"},
                            ).then((value) async {
                              if (value["saved"] == true) {
                                final _solde = int.parse(users!.solde!);
                                final _montant = int.parse(montant);
                                user.solde = '${_solde + _montant}';

                                await Api.saveObjetApi(
                                  arguments: user,
                                  url: Url.UsersUrl,
                                  additionalArgument: {"action": "SAVE"},
                                ).then((value) async {
                                  setState(() {
                                    sendPayment = false;
                                  });
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  NToastWidget().showToastStyle(
                                    context,
                                    message: "Paiement effectué avec succès",
                                    alerteetat: ALERTEETAT.SUCCES,
                                  );
                                  final notif = Notifications(
                                    titre: "Rechargement de compte",
                                    message: "Vous venez de recharger votre compte de ${_montant} ${pays.symbole_monnaie}",
                                    user_id: user.id,
                                    type_notification: "welcome",
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
                                  getUsers();
                                });
                              }
                            });
                          });
                        } catch (e) {
                          print("erreur in third catch: $e");
                          setState(() {
                            sendPayment = false;
                          });
                          NToastWidget().showToastStyle(
                            context,
                            message: "Une erreur s'est produite",
                            alerteetat: ALERTEETAT.ERREUR,
                          );
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }),
      );
    } else {
      setState(() {
        sendPayment = true;
      });
      Fonctions().showWidgetAsDialog(
        context: context,
        titleWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                "Indisponible pour votre pays",
                style: Style.defaultTextStyle(textSize: 12.0),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: theme.primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        widget: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Cette option n'est pas disponible  pour votre pays",
                  style: Style.defaultTextStyle(textSize: 10.0, textOverflow: null),
                ),
              ),
            ],
          ),
        ),
      );
      setState(() {
        sendPayment = false;
      });
    }
  }

  void getFrais() async {
    list_frais = await Preferences().getFraisListFromLocal();
    setState(() {});
  }

  @override
  void initState() {
    getUsers();
    super.initState();
    getFrais();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(3, 5),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 25, right: 20, left: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              getUsers();
                            },
                            padding: EdgeInsets.zero,
                            icon: NAnimatorWidget(
                              startAnimation: getDataUsers,
                              child: Icon(
                                Icons.refresh,
                                color: theme.primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15.0),
                      GestureDetector(
                        onTap: () {
                          Fonctions().openPageToGo(
                            context: context,
                            pageToGo: AppHomePage(
                              users: users!,
                              currentIndex: 4,
                            ),
                            replacePage: true,
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/user_g.png",
                                  ),
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "${users != null ? users!.nom : "..."} ${users != null ? users!.prenom : "..."}",
                                    style: Style.defaultTextStyle(),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    width: 20.0,
                                    height: 5.0,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      NButtonWidget(
                                        iconData: MdiIcons.transferUp,
                                        rounded: true,
                                        showShadow: false,
                                        action: () {
                                          if (users != null && users!.isVerifier) {
                                            Fonctions().openPageToGo(
                                              context: context,
                                              pageToGo: AppSendMoney(),
                                            );
                                          } else if (users != null &&
                                              users!.isNonVerifier &&
                                              (users!.lien_adresse!.isNotEmpty || users!.lien_cni!.isNotEmpty)) {
                                            Fonctions().showWidgetAsDialog(
                                              context: context,
                                              titleWidget: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      "Avertissement",
                                                      style: Style.defaultTextStyle(textSize: 12.0, textColor: Colors.red),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              widget: Container(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Vos informations sont en cours de traitement. Veuillez réessayer plus tard",
                                                        style: Style.defaultTextStyle(textSize: 10.0, textOverflow: null),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            Fonctions().openPageToGo(
                                              context: context,
                                              pageToGo: AppErrorCritiquePage(
                                                users: users,
                                                showAppBar: true,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(width: 30.0),
                                      NButtonWidget(
                                        iconData: MdiIcons.transferDown,
                                        rounded: true,
                                        showShadow: false,
                                        load: sendPayment,
                                        action: () async {
                                          Fonctions().showWidgetAsDialog(
                                            context: context,
                                            title: "Actions Disponibles",
                                            widget: StatefulBuilder(
                                              builder: (context, setState) {
                                                return Container(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: NButtonWidget(
                                                              text: "Effectuer un dépôt",
                                                              action: () {
                                                                Fonctions().openPageToGo(
                                                                  context: context,
                                                                  pageToGo: AppScanQrCodePage(
                                                                    type_transfert: cn.TYPE_OPERATION.DEPOT.name.toLowerCase(),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: NButtonWidget(
                                                              text: "Effectuer un retrait",
                                                              isOutline: true,
                                                              action: () {
                                                                Fonctions().openPageToGo(
                                                                  context: context,
                                                                  pageToGo: AppScanQrCodePage(
                                                                    type_transfert: cn.TYPE_OPERATION.RETRAIT.name.toLowerCase(),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: NButtonWidget(
                                                              text: "Recharger mon compte",
                                                              backColor: theme.colorScheme.secondary,
                                                              action: () {
                                                                Navigator.pop(context);
                                                                rechargementCompteLiso();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "${users != null ? users!.solde!.isNotEmpty ? users!.solde : "0" : "..."} ${users != null && users!.pays != null ? users!.pays!.symbole_monnaie : "..."}",
                                  style: Style.defaultTextStyle(
                                    font: GoogleFonts.nunito().fontFamily,
                                    textWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Solde (${users != null && users!.pays != null ? users!.pays!.nom : "..."})",
                                  style: Style.defaultTextStyle(textSize: 8.0, textWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 0.5,
                            height: 40,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          if (pays_now != null && pays_now != users?.pays)
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "${users != null ? users!.solde!.isNotEmpty ? "${double.tryParse("${int.parse(users!.solde!) * currency!.value!}")!.toStringAsFixed(0)}" : "0" : "..."} ${pays_now != null ? pays_now!.symbole_monnaie : "..."}",
                                    style: Style.defaultTextStyle(
                                      font: GoogleFonts.nunito().fontFamily,
                                      textWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Solde (${pays_now != null ? pays_now!.nom : "..."})",
                                    style: Style.defaultTextStyle(textSize: 8.0, textWeight: FontWeight.w100),
                                  ),
                                ],
                              ),
                            ),
                          if (pays_now != null && pays_now != users?.pays)
                            Container(
                              width: 0.5,
                              height: 40,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          Expanded(
                            child: InkWell(
                              onTap: users != null
                                  ? () async {
                                      if (users!.code_secret!.isNotEmpty) {
                                        Fonctions().shareApp(
                                            sujet: "Recevoir de l'argent à travers l'application",
                                            text:
                                                "🚀 LISOCASH 🚀\nBesoin de vous envoyer de l'argent rapidement et en toute sécurité ? Utilisez mon code de transfert :\n${users!.code_secret}\nRendez-vous sur Lisocash pour effectuer le transfert. Merci ! 💸");
                                      } else {
                                        NToastWidget().showToastStyle(
                                          context,
                                          closeAutomatically: true,
                                          showActionAsLoad: true,
                                          alerteetat: ALERTEETAT.AVERTISSEMENT,
                                          message: "Génération du code en cours.",
                                        );

                                        final code = "Lisocash#trans#${Fonctions().generateV4().toString().substring(0, 8)}";
                                        final user = users;

                                        user!.code_secret = code;

                                        Map<String, String> paramsSup = {
                                          "action": "SAVE",
                                        };

                                        await Api.saveObjetApi(arguments: user, url: Url.UsersUrl, additionalArgument: paramsSup).then(
                                          (value) {
                                            if (value["saved"] == true) {
                                              Preferences.removeData(key: "${Preferences.PREFS_KEY_UsersID}");
                                              Preferences.saveData(key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
                                              getUsers();
                                              ScaffoldMessenger.of(context).clearSnackBars();
                                            }
                                          },
                                        );
                                      }
                                    }
                                  : null,
                              child: Column(
                                children: [
                                  Text(
                                    "${users != null ? users!.code_secret!.isNotEmpty ? users!.code_secret!.replaceRange(0, users!.code_secret!.length - 5, "****") : "****" : "..."}",
                                    style: Style.defaultTextStyle(
                                      font: GoogleFonts.nunito().fontFamily,
                                      textWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Code",
                                    style: Style.defaultTextStyle(textSize: 8.0, textWeight: FontWeight.w100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Récents",
                      style: Style.defaultTextStyle(
                        textWeight: FontWeight.w800,
                        textSize: 20.0,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      onPressed: () {
                        Fonctions().openPageToGo(
                          context: context,
                          pageToGo: OperationListWidget(
                            user_id: users!.id.toString(),
                            showAsGrid: true,
                            showAppBar: true,
                            title: "Liste de mes opérations",
                            showItemAsCard: true,
                            message_error: "Vous n'avez réalisé aucune transaction aujourd'hui !",
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Afficher plus",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Style.defaultTextStyle(textSize: 10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.all(8.0),
                child: getDataOperations
                    ? Column(
                        children: [
                          SizedBox(height: 50.0),
                          NLoadingWidget(),
                        ],
                      )
                    : listOperations.isNotEmpty
                        ? Column(
                            children: listOperations
                                .map((e) => VueOperation(
                                      operation: e,
                                      showAsCard: true,
                                    ))
                                .toList(),
                          )
                        : Container(
                            height: 320,
                            child: NErrorWidget(
                              message: "Vous n'avez effectué aucune transaction au cours de la journée !",
                            ),
                          ),
              ),
              /*Container(
                height: 320,
                child: OperationListWidget(
                  key: ValueKey<String>(users.toString()),
                  showItemAsCard: true,
                  user_id: users != null ? users!.id.toString() : null,
                  showAsGrid: true,
                  message_error: "Vous n'avez effectué aucune transaction au cours de la journée !",
                  showOnlyForToday: true,
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
