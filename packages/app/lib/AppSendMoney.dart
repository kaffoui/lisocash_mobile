import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Frais.dart';
import 'package:noyaux/models/Pays.dart';
import 'package:noyaux/models/Taux.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/pages/components/MyBodyPage.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/widgets/N_DropDownWidget.dart';
import 'package:noyaux/widgets/N_LoadingWidget.dart';
import 'package:noyaux/widgets/N_TextInputWidget.dart';

class AppSendMoney extends StatefulWidget {
  const AppSendMoney({super.key});

  @override
  State<AppSendMoney> createState() => _AppSendMoneyState();
}

class _AppSendMoneyState extends State<AppSendMoney> {
  bool getUserInfos = false, send_data = false;

  late Color backgroundColor;

  Users? userConnected;

  List<Frais> frais = [];
  List<Taux> taux = [];
  List<Pays> pays = [];

  Pays? initialPays;

  void getUsersInfos() async {
    final id = await Preferences().getIdUsers();
    userConnected = await Preferences(skipLocal: true).getUsersListFromLocal(id: id).then((value) => value.first);
    setState(() {});
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
      pays.clear();
      pays.addAll(_pays);
      initialPays = _initialPays;
    });
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
      body: MyBodyPage(
        backColor: backgroundColor,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.white.withOpacity(.9),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "Pays de destination",
                              style: Style.defaultTextStyle(),
                            ),
                          ),
                        ],
                      ),
                      if (initialPays != null && pays.isNotEmpty)
                        NDropDownWidget(
                          initialObject: initialPays,
                          listObjet: pays,
                          buildItem: (pays) {
                            final _pays = pays as Pays;
                            return NDropDownModelWidget(
                              title: "${_pays.nom}",
                              imgLink: _pays.url_drapeau,
                            );
                          },
                          onChangedDropDownValue: (value) {
                            setState(() {
                              initialPays = value;
                            });
                          },
                        ),
                      if (initialPays == null && pays.isEmpty)
                        Column(
                          children: [
                            SizedBox(height: 12.0),
                            NLoadingWidget(width: 20.0, height: 20.0),
                          ],
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "Montant à envoyer",
                              style: Style.defaultTextStyle(),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(height: 12.0),
                          NTextInputWidget(
                            border: Border.all(color: Colors.transparent),
                            showUnderline: true,
                          ),
                          SizedBox(height: 12.0),
                          NTextInputWidget(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
