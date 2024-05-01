import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Currency.dart';
import 'package:noyaux/models/Frais.dart';
import 'package:noyaux/models/Notifications.dart';
import 'package:noyaux/models/Operation.dart';
import 'package:noyaux/models/Pays.dart';
import 'package:noyaux/models/Taux.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/modelsLists/UsersListWidget.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_DisplayTextWidget.dart';
import 'package:noyaux/widgets/N_DropDownWidget.dart';
import 'package:noyaux/widgets/N_LoadingWidget.dart';
import 'package:noyaux/widgets/N_RadioButtonWidget.dart';
import 'package:noyaux/widgets/N_TextInputWidget.dart';
import 'package:noyaux/widgets/N_ToastWidget.dart';

import 'AppHomePage.dart';

class AppSendMoney extends StatefulWidget {
  const AppSendMoney({super.key});

  @override
  State<AppSendMoney> createState() => _AppSendMoneyState();
}

class _AppSendMoneyState extends State<AppSendMoney> {
  bool getUserInfos = false, send_data = false, fetch_currency = false, send_transaction = false, cannot_enter_solde = false;

  int _valuePaiement = 1;

  late Color backgroundColor;
  late ThemeData theme;

  TextEditingController montant = TextEditingController(), montant_recu = TextEditingController(), userToSendController = TextEditingController();

  GlobalKey<FormFieldState> montantKey = GlobalKey<FormFieldState>(),
      montant_recuKey = GlobalKey<FormFieldState>(),
      userToSendControllerKey = GlobalKey<FormFieldState>();

  final isSelected = <bool>[false, false];

  Users? userConnected, userToSend;
  Currency? currency;

  Map<String, dynamic>? paymentIntent;

  String solde = "0", message_a_afficher = "", motif = motifsList.first;

  List<Frais> frais = [];
  List<Taux> taux = [];
  List<Pays> pays = [];

  Pays? initialPays, paysUser;
  Frais? selectedFrais;
  Taux? selectedTaux;

  void getUsersInfos() async {
    final id = await Preferences().getIdUsers();
    userConnected = await Preferences(skipLocal: true).getUsersListFromLocal(id: id).then((value) => value.first);
    setState(() {
      checkSolde();
    });
  }

  void getFraisList() async {
    final _frais = await Preferences().getFraisListFromLocal();

    setState(() {
      frais.clear();
      frais.addAll(_frais);
    });
  }

  void getTauxList() async {
    final _taux = await Preferences().getTauxListFromLocal();
    setState(() {
      taux.clear();
      taux.addAll(_taux);
    });
  }

  void getPaysList() async {
    var _pays = await Preferences().getPaysListFromLocal();
    final _initialPays = await Fonctions().getPaysFromIp();
    setState(() {
      _pays.sort((a, b) => a.nom!.toLowerCase().compareTo(b.nom!.toLowerCase()));

      _pays = _pays
          .where((element) =>
              element.continent!.toLowerCase() == "africa" ||
              element.continent!.toLowerCase() == "europe" ||
              element.continent!.toLowerCase() == "north america" ||
              element.continent!.toLowerCase() == "south america" ||
              element.continent!.toLowerCase() == "asia")
          .toList();
      pays.clear();
      pays.addAll(_pays);
      initialPays = _initialPays;
      paysUser = _initialPays;
      if (initialPays != paysUser) {
        fetchCurrency(paysUser!.symbole_monnaie.toString(), initialPays!.symbole_monnaie.toString());
      }
    });
  }

  void save_operation({
    required Operation operation,
    required int nouveauMontantEnvoyer,
    required int nouveauMontantRecevoir,
    required Users user_from,
    required Users user_to,
  }) async {
    operation.type_operation = "transfert";
    operation.montant = "${nouveauMontantEnvoyer}~${nouveauMontantRecevoir}";
    operation.motif = motif;
    operation.date_envoie = DateTime.now().toString();
    operation.id = 0;
    operation.frais_id = selectedFrais!.id;
    operation.taux_id = 0;
    operation.etat_operation = ETAT_OPERATION.TERMINER.name.toLowerCase();
    operation.date_reception = DateTime.now().toString();
    operation.date_enregistrement = DateTime.now().toString();

    setState(() {
      message_a_afficher = "Enrégistrement de votre paiement...";
    });

    await Api.saveObjetApi(arguments: operation, url: Url.OperationUrl, additionalArgument: {"action": "SAVE"}).then((value) async {
      if (value["saved"] == true) {
        setState(() {
          message_a_afficher = "Modification de vos information";
        });
        await Api.saveObjetApi(arguments: user_from, url: Url.UsersUrl, additionalArgument: {"action": "SAVE"}).then((value) async {
          if (value["saved"] == true) {
            await Api.saveObjetApi(arguments: user_to, url: Url.UsersUrl, additionalArgument: {
              "action": "SAVE",
            }).then((value) async {
              setState(() {
                message_a_afficher = "Paiement effectué avec succès";
              });

              Fonctions().showErrorAsWidget(
                context: context,
                message: "Votre paiement à été effectué avec succès.",
                assetPath: "assets/images/success.png",
                buttonText: "Allez à l'acceuil",
                action: () {
                  Fonctions().openPageToGo(
                    context: context,
                    pageToGo: AppHomePage(users: user_from),
                    replacePage: true,
                  );
                },
                typewidgeterror: TYPEWIDGETERROR.BOTTOMSHEET,
              );

              final notif_user_from = Notifications(
                titre: "Transfert",
                message:
                    "Vous venez d'envoyer de votre compte un montant de ${nouveauMontantEnvoyer} ${user_to.pays!.symbole_monnaie} à ${user_to.nom} ${user_to.prenom}",
                user_id: operation.user_id_from,
                type_notification: "welcome",
                priorite: "normal",
              );

              await Api.saveObjetApi(
                arguments: notif_user_from,
                additionalArgument: {
                  'action': 'SAVE',
                  'send_notif': '1',
                  'fcm_token': '${user_from.fcm_token}',
                },
                url: Url.NotificationsUrl,
              );

              final notif_user_to = Notifications(
                titre: "Transfert",
                message:
                    "Vous venez d'envoyer de recevoir un montant de ${nouveauMontantEnvoyer} ${user_to.pays!.symbole_monnaie} de la part de ${user_from.nom} ${user_from.prenom}",
                user_id: operation.user_id_from,
                type_notification: "welcome",
                priorite: "normal",
              );

              await Api.saveObjetApi(
                arguments: notif_user_to,
                additionalArgument: {
                  'action': 'SAVE',
                  'send_notif': '1',
                  'fcm_token': '${user_to.fcm_token}',
                },
                url: Url.NotificationsUrl,
              );
            });
          }
        });
      } else {
        setState(() {
          message_a_afficher = "Une erreur s'est produite...";
          send_transaction = false;
        });
      }
    });
  }

  void fetchCurrency(String base, String target) async {
    setState(() {
      fetch_currency = true;
    });
    final data = await Api().fetchExchangeRate(base, target);
    setState(() {
      currency = data;
      checkMontant();
      fetch_currency = false;
    });
  }

  Future<bool> payment(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "currency": currency,
      };

      print("body: $body");

      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: {'Authorization': 'Bearer ${Constants.STRIPE_DEV_SECRET}', 'Content-type': 'application/x-www-form-urlencoded'},
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
        await Stripe.instance
            .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!["client_secret"],
                style: ThemeMode.system,
                merchantDisplayName: "LISOCASH",
              ),
            )
            .then((value) {});
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        NToastWidget().showToastStyle(
          context,
          message: "Une erreur s'est produite..",
          alerteetat: ALERTEETAT.ERREUR,
        );
      }
    }

    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ScaffoldMessenger.of(context).clearSnackBars();
        NToastWidget().showToastStyle(
          context,
          message: "Paiement effectué avec succès",
          alerteetat: ALERTEETAT.SUCCES,
        );
      });
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      NToastWidget().showToastStyle(
        context,
        message: "Une erreur s'est produite..",
        alerteetat: ALERTEETAT.ERREUR,
      );

      return false;
    }
  }

  void checkMontant() {
    if (montant.text.isNotEmpty) {
      if (currency != null) {
        setState(() {
          final val = int.tryParse(montant.text);
          montant_recu.text = double.tryParse("${val! * currency!.value!}")!.toStringAsFixed(0);
          print("cur: ${currency!.value} montant: ${montant_recu.text}");
        });
      } else {
        setState(() {
          montant_recu.text = montant.text;
        });
      }
    } else {
      setState(() {
        montant_recu.clear();
      });
    }
  }

  void checkSolde([String? new_montant]) {
    if (montant.text.isNotEmpty || new_montant != null) {
      final _solde = int.parse(userConnected!.solde!);
      final _montant = new_montant != null ? int.parse(new_montant) : int.tryParse(montant.text);
      print("mnt: $_montant");
      if (_montant! <= _solde) {
        setState(() {
          solde = "${double.tryParse("$_solde")! - double.tryParse("$_montant")!}";
          cannot_enter_solde = false;
        });
      } else {
        setState(() {
          cannot_enter_solde = true;
        });
      }
    } else {
      setState(() {
        solde = userConnected!.solde!;
      });
    }
  }

  @override
  void initState() {
    backgroundColor = Colors.white;

    getUsersInfos();
    getFraisList();
    getTauxList();
    getPaysList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Nouveau transfert",
          style: Style.defaultTextStyle(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: pays.isNotEmpty && initialPays != null
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    NDropDownWidget(
                      title: "Pays de réception",
                      initialObject: initialPays,
                      listObjet: pays,
                      buildItem: (valuePays) {
                        final _valuePays = valuePays as Pays;
                        return NDropDownModelWidget(
                          title: _valuePays.nom,
                          imgLink: _valuePays.url_drapeau,
                        );
                      },
                      onChangedDropDownValue: (value) {
                        setState(() {
                          initialPays = value;
                        });
                        fetchCurrency(paysUser!.symbole_monnaie.toString(), initialPays!.symbole_monnaie.toString());
                      },
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: NDisplayTextWidget(
                                  text: "Moyens de paiement",
                                  theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                ),
                              ),
                            ],
                          ),
                          NRadioButtonWidget<int>(
                            value: 1,
                            groupValue: _valuePaiement,
                            leadingIcon: Icons.wallet,
                            title: Text('Lisocash'),
                            onChanged: (value) => setState(
                              () {
                                _valuePaiement = value!;
                                checkSolde();
                              },
                            ),
                          ),
                          if (paysUser != null && paysUser!.continent != "Africa")
                            NRadioButtonWidget<int>(
                              value: 2,
                              groupValue: _valuePaiement,
                              leadingIcon: Icons.wallet,
                              title: Text('Cartes'),
                              onChanged: (value) => setState(
                                () => _valuePaiement = value!,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: NDisplayTextWidget(
                                  text: "Montant",
                                  theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                ),
                              ),
                            ),
                            if (_valuePaiement == 1)
                              Column(
                                children: [
                                  Text(
                                    cannot_enter_solde ? "Solde insuffisant" : "Solde: $solde ${userConnected?.pays?.symbole_monnaie}",
                                    style: Style.defaultTextStyle(
                                      textSize: 10.0,
                                      textColor: cannot_enter_solde ? Colors.red : null,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        NCardWidget(
                          cardColor: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              children: <Widget>[
                                NTextInputWidget(
                                  textController: montant,
                                  validationKey: montantKey,
                                  title: "Montant à envoyer",
                                  isNumeric: true,
                                  isRequired: true,
                                  rightWidget: NDisplayTextWidget(
                                    text: "${paysUser?.symbole_monnaie}",
                                    theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    checkMontant();
                                    if (_valuePaiement == 1) {
                                      checkSolde();
                                    }
                                  },
                                ),
                                SizedBox(height: 12.0),
                                NTextInputWidget(
                                  title: "Montant à recevoir",
                                  readOnly: true,
                                  isNumeric: true,
                                  isRequired: true,
                                  textController: montant_recu,
                                  validationKey: montant_recuKey,
                                  rightWidget: NDisplayTextWidget(
                                    text: "${initialPays?.symbole_monnaie}",
                                    theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                  ),
                                ),
                                if (fetch_currency)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      AnimatedDefaultTextStyle(
                                        child: Text("..."),
                                        style: Style.defaultTextStyle(),
                                        duration: Duration(
                                          milliseconds: 1500,
                                        ),
                                      )
                                    ],
                                  ),
                                if (currency != null && !fetch_currency && initialPays != paysUser)
                                  Container(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        NDisplayTextWidget(
                                          text:
                                              "1 ${paysUser?.symbole_monnaie} ~= ${currency!.value!.toStringAsFixed(0)} ${initialPays?.symbole_monnaie}",
                                          theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                        ),
                                      ],
                                    ),
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
                                                      text: "${selectedFrais!.frais_pourcentage} % ",
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
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  "Total : ${(double.tryParse(montant.text)! * double.tryParse(selectedFrais!.frais_pourcentage!)!).toStringAsFixed(0)} (${paysUser?.symbole_monnaie})",
                                                  textAlign: TextAlign.end,
                                                  style: Style.defaultTextStyle(textSize: 10.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  "Total : ${(double.tryParse(montant_recu.text)! * double.tryParse(selectedFrais!.frais_pourcentage!)!).toStringAsFixed(0)} (${initialPays?.symbole_monnaie})",
                                                  textAlign: TextAlign.end,
                                                  style: Style.defaultTextStyle(textSize: 10.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 6.0),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: NDisplayTextWidget(
                                  text: "Motif de transaction",
                                  theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                ),
                              ),
                            ),
                          ],
                        ),
                        NDropDownWidget(
                          initialObject: motif,
                          listObjet: motifsList,
                          onChangedDropDownValue: (value) {
                            setState(() {
                              motif = value;
                            });
                          },
                        ),
                        SizedBox(height: 6.0),
                        NTextInputWidget(
                          title: "Destinataire",
                          textController: userToSendController,
                          validationKey: userToSendControllerKey,
                          isRequired: true,
                          readOnly: true,
                          onTap: () {
                            Fonctions().showWidgetAsModalSheet(
                              context: context,
                              useSafeArea: true,
                              useConstraint: true,
                              maxHeight: 650,
                              title: "Destinataire",
                              widget: Builder(builder: (ctx) {
                                return Container(
                                  height: 550,
                                  child: UsersListWidget(
                                    title: "Destinataire",
                                    skipLocalData: true,
                                    customMessage: "Aucun utilisateur pour ${initialPays?.nom}",
                                    filterByPays: initialPays,
                                    removeMe: true,
                                    showOnlyValidated: true,
                                    showSearchBar: true,
                                    onItemPressed: (value) {
                                      final _value = value as Users;
                                      userToSendController.text = "${_value.nom} ${_value.prenom}";
                                      userToSend = _value;
                                      Navigator.pop(ctx);
                                    },
                                    backColor: Colors.transparent,
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                        SizedBox(height: 6.0),
                        if (message_a_afficher.isNotEmpty)
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: NDisplayTextWidget(
                                    text: "$message_a_afficher",
                                    textAlign: TextAlign.center,
                                    theme: BASE_TEXT_THEME.LABEL_SMALL,
                                    fontWeight: FontWeight.w700,
                                    softWrap: true,
                                    overflow: null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 6.0),
                        Row(
                          children: [
                            Expanded(
                              child: NButtonWidget(
                                text: "Payer",
                                load: send_transaction,
                                action: () async {
                                  if (montantKey.currentState!.validate() && userToSendControllerKey.currentState!.validate()) {
                                    try {
                                      setState(() {
                                        send_transaction = true;
                                        message_a_afficher = "Paiement en cours...";
                                      });

                                      final operation = Operation();

                                      if (frais.isNotEmpty) {
                                        var _frais;
                                        setState(() {
                                          if (_valuePaiement == 1) {
                                            _frais = frais
                                                .where((element) =>
                                                    ((element.moyen_paiement!.toLowerCase() == "lisocash" &&
                                                        element.operation_type!.toLowerCase() == "transfert")) &&
                                                    (element.from!.toLowerCase() == paysUser?.region!.toLowerCase() &&
                                                        element.to!.toLowerCase() == initialPays?.region!.toLowerCase()))
                                                .toList();
                                          } else {
                                            _frais = frais
                                                .where((element) =>
                                                    ((element.moyen_paiement!.toLowerCase() == "stripe" &&
                                                        element.operation_type!.toLowerCase() == "transfert")) &&
                                                    (element.from!.toLowerCase() == paysUser?.region!.toLowerCase() &&
                                                        element.to!.toLowerCase() == initialPays?.region!.toLowerCase()))
                                                .toList();
                                          }
                                        });

                                        print("_frais: $_frais");

                                        if (_frais.isNotEmpty) {
                                          setState(() {
                                            selectedFrais = _frais.first;
                                          });
                                        }

                                        final nouveauMontantEnvoyer =
                                            "${(double.tryParse(montant.text)! * double.tryParse(selectedFrais!.frais_pourcentage!)!).toStringAsFixed(0)}";

                                        if (_valuePaiement == 1) {
                                          checkSolde(nouveauMontantEnvoyer);
                                        }

                                        final user_from = userConnected;
                                        final user_to = userToSend;

                                        user_from!.solde = solde;
                                        user_to!.solde = "${int.tryParse(user_to.solde!)! + int.parse(montant_recu.text)}";

                                        operation.user_id_from = user_from.id;
                                        operation.user_id_to = user_to.id;

                                        if (_valuePaiement == 1) {
                                          // Lisocash
                                          save_operation(
                                            operation: operation,
                                            nouveauMontantEnvoyer: int.parse(nouveauMontantEnvoyer),
                                            nouveauMontantRecevoir: int.parse(montant.text),
                                            user_from: user_from,
                                            user_to: user_to,
                                          );
                                        } else {
                                          // Stripe
                                          await payment("$nouveauMontantEnvoyer", "${paysUser!.symbole_monnaie}").then((value) {
                                            if (value) {
                                              save_operation(
                                                operation: operation,
                                                nouveauMontantEnvoyer: int.parse(nouveauMontantEnvoyer),
                                                nouveauMontantRecevoir: int.parse(montant.text),
                                                user_from: user_from,
                                                user_to: user_to,
                                              );
                                            }
                                          });
                                        }
                                      }
                                    } catch (e) {
                                      setState(() {
                                        send_transaction = false;
                                        message_a_afficher = "$e";
                                      });
                                    }
                                  } else {
                                    montantKey.currentState!.validate();
                                    userToSendControllerKey.currentState!.validate();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: NLoadingWidget(
                  message: "Chargement des informations nécéssaires. Veuillez patientez...",
                ),
              ),
      ),
    );
  }
}
