import 'package:flutter/material.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Currency.dart';
import 'package:noyaux/models/Frais.dart';
import 'package:noyaux/models/Pays.dart';
import 'package:noyaux/models/Taux.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/modelsLists/UsersListWidget.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_DisplayTextWidget.dart';
import 'package:noyaux/widgets/N_DropDownWidget.dart';
import 'package:noyaux/widgets/N_LoadingWidget.dart';
import 'package:noyaux/widgets/N_RadioButtonWidget.dart';
import 'package:noyaux/widgets/N_TextInputWidget.dart';

class AppSendMoney extends StatefulWidget {
  const AppSendMoney({super.key});

  @override
  State<AppSendMoney> createState() => _AppSendMoneyState();
}

class _AppSendMoneyState extends State<AppSendMoney> {
  bool getUserInfos = false,
      send_data = false,
      fetch_currency = false,
      send_transaction = false,
      cannot_enter_solde = false;

  int _valuePaiement = 1;

  late Color backgroundColor;
  late ThemeData theme;

  TextEditingController montant = TextEditingController(),
      montant_recu = TextEditingController(),
      userToSendController = TextEditingController();

  GlobalKey<FormFieldState> montantKey = GlobalKey<FormFieldState>(),
      montant_recuKey = GlobalKey<FormFieldState>(),
      userToSendControllerKey = GlobalKey<FormFieldState>();

  final isSelected = <bool>[false, false];

  Users? userConnected, userToSend;
  Currency? currency;

  String solde = "0";

  List<Frais> frais = [];
  List<Taux> taux = [];
  List<Pays> pays = [];

  Pays? initialPays, paysUser;
  Frais? selectedFrais;
  Taux? selectedTaux;

  void getUsersInfos() async {
    final id = await Preferences().getIdUsers();
    userConnected = await Preferences(skipLocal: true)
        .getUsersListFromLocal(id: id)
        .then((value) => value.first);
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
    final _pays = await Preferences().getPaysListFromLocal();
    final _initialPays = await Fonctions().getPaysFromIp();
    setState(() {
      _pays.sort((a, b) => a.nom!.toLowerCase().compareTo(b.nom!.toLowerCase()));
      pays.clear();
      pays.addAll(_pays);
      initialPays = _initialPays;
      paysUser = _initialPays;
      if (initialPays != paysUser) {
        fetchCurrency(
            paysUser!.symbole_monnaie.toString(), initialPays!.symbole_monnaie.toString());
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

  void checkMontant() {
    if (montant.text.isNotEmpty) {
      if (currency != null) {
        setState(() {
          final val = int.tryParse(montant.text);
          montant_recu.text = double.tryParse("${val! * currency!.value!}")!.toStringAsFixed(2);
          print("cur: ${currency!.value} montant: ${montant_recu.text}");
        });
      }
    } else {
      setState(() {
        montant_recu.clear();
      });
    }
  }

  void checkSolde() {
    if (montant.text.isNotEmpty) {
      final _solde = int.tryParse(userConnected!.solde!);
      final _montant = int.tryParse(montant.text);
      if (_montant! <= _solde!) {
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
                        fetchCurrency(paysUser!.symbole_monnaie.toString(),
                            initialPays!.symbole_monnaie.toString());
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
                                    cannot_enter_solde
                                        ? "Solde insuffisant"
                                        : "Solde: $solde ${userConnected?.pays?.symbole_monnaie}",
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
                                              "1 ${paysUser?.symbole_monnaie} ~= ${currency!.value} ${initialPays?.symbole_monnaie}",
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
                                                      text:
                                                          "${selectedFrais!.frais_pourcentage} % ",
                                                      style: Style.defaultTextStyle(
                                                          textSize: 10.0,
                                                          textWeight: FontWeight.w700),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "seront appliqués lors de la transaction.",
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
                                                  "Total : ${(double.tryParse(montant.text)! * double.tryParse(selectedFrais!.frais_pourcentage!)!).toStringAsFixed(2)} (${paysUser?.symbole_monnaie})",
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
                                                  "Total : ${(double.tryParse(montant_recu.text)! * double.tryParse(selectedFrais!.frais_pourcentage!)!).toStringAsFixed(2)} (${initialPays?.symbole_monnaie})",
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
                        SizedBox(height: 12.0),
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
                        SizedBox(height: 12.0),
                        Row(
                          children: [
                            Expanded(
                              child: NButtonWidget(
                                text: "Payer",
                                load: send_transaction,
                                action: () {
                                  if (montantKey.currentState!.validate() &&
                                      userToSendControllerKey.currentState!.validate()) {
                                    if (frais.isNotEmpty) {
                                      setState(() {
                                        final _frais = frais
                                            .where((element) =>
                                                (_valuePaiement == 1
                                                    ? (element.moyen_paiement!.toLowerCase() ==
                                                            "lisocash" &&
                                                        element.operation_type!.toLowerCase() ==
                                                            "transfert")
                                                    : (element.moyen_paiement!.toLowerCase() ==
                                                            "stripe" &&
                                                        element.operation_type!.toLowerCase() ==
                                                            "transfert")) &&
                                                (element.from!.toLowerCase() ==
                                                        paysUser?.region!.toLowerCase() &&
                                                    element.to!.toLowerCase() ==
                                                        initialPays?.region!.toLowerCase()))
                                            .toList();
                                        if (_frais.isNotEmpty) {
                                          print('list: $_frais');
                                        }
                                      });

                                      print("frais: ${selectedFrais}");
                                    }

                                    if (taux.isNotEmpty) {}
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
