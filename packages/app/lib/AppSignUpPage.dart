import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Pays.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/pages/components/MyBodyPage.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_DropDownWidget.dart';
import 'package:noyaux/widgets/N_ExpandableWidget.dart';
import 'package:noyaux/widgets/N_MediaWidget.dart';
import 'package:noyaux/widgets/N_TextInputWidget.dart';
import 'package:noyaux/widgets/N_ToastWidget.dart';

import 'AppHomePage.dart';

class AppSignUpPage extends StatefulWidget {
  const AppSignUpPage({super.key});

  @override
  State<AppSignUpPage> createState() => _AppSignUpPageState();
}

class _AppSignUpPageState extends State<AppSignUpPage> {
  PageController pageController = PageController();

  bool send = false, getPays = false, verifyPhone = false, isVerify = false, checkPhone = false, ignore = false, codeSent = true;

  Users? users;

  Pays? initialPays;
  List<Pays> listPays = [];

  List<int> adresseByte = [], cniByte = [];

  String codeTelephonique = "+229", adresseName = "", cniName = "";
  late GENRE genreUsers;

  int currentPage = 0;

  void onPageChanged(Users newUsers) {
    setState(() {
      users = newUsers;
    });
    print("users: $users");
    pageController.nextPage(
      duration: Duration(milliseconds: 1500),
      curve: Curves.ease,
    );
  }

  TextEditingController nomController = TextEditingController(),
      prenomController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController(),
      adresseController = TextEditingController(),
      quartierController = TextEditingController(),
      villeController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController(),
      otpController = TextEditingController();

  GlobalKey<FormFieldState> nomKey = GlobalKey<FormFieldState>(),
      prenomKey = GlobalKey<FormFieldState>(),
      emailKey = GlobalKey<FormFieldState>(),
      phoneKey = GlobalKey<FormFieldState>(),
      adresseKey = GlobalKey<FormFieldState>(),
      quartierKey = GlobalKey<FormFieldState>(),
      villeKey = GlobalKey<FormFieldState>(),
      passwordKey = GlobalKey<FormFieldState>(),
      confirmPasswordKey = GlobalKey<FormFieldState>(),
      otpKey = GlobalKey<FormFieldState>();

  bool state = true;

  late ThemeData theme;

  void getPayslist() async {
    setState(() {
      getPays = true;
    });
    final _selectedPays = await Fonctions().getPaysFromIp();
    final data = await Preferences().getPaysListFromLocal();
    print("data: $data");
    if (data.isNotEmpty) {
      listPays.addAll(data);
      listPays.sort((a, b) => a.nom!.toLowerCase().compareTo(b.nom!.toLowerCase()));
      setState(() {
        initialPays = _selectedPays;
        codeTelephonique = initialPays!.indicatif!;
        getPays = false;
      });
    }
  }

  @override
  void initState() {
    getPayslist();
    genreUsers = genreListe.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return MyBodyPage(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.white.withOpacity(.7),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(height: 14.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        child: Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: BoxDecoration(
                            color: index == currentPage ? theme.colorScheme.secondary : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          margin: EdgeInsets.only(right: 5.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    children: [
                      _takeDataUser(),
                      _takePhoneAndVerify(),
                      _adresseDataUser(),
                      _connexionData(),
                      _sendData(),
                      _verifyAdresse(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _takeDataUser() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Veuillez fournir vos informations personnelles.",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Vos informations doivent respecter les informations sur votre carte d'identité.",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          NTextInputWidget(
            textController: nomController,
            validationKey: nomKey,
            title: "Nom(s)",
            isRequired: true,
            leftIcon: Icons.person,
            onChanged: (_) {
              nomKey.currentState!.validate();
              setState(() {});
            },
          ),
          NTextInputWidget(
            textController: prenomController,
            validationKey: prenomKey,
            title: "Prenom(s)",
            isRequired: true,
            leftIcon: Icons.person,
            onChanged: (_) {
              prenomKey.currentState!.validate();
              setState(() {});
            },
          ),
          NDropDownWidget(
            title: "Sexe",
            initialObject: genreUsers,
            isRequired: true,
            listObjet: genreListe,
            buildItem: (value) {
              final genre = value as GENRE;
              return NDropDownModelWidget(
                title: "${genre.name}",
              );
            },
            onChangedDropDownValue: (value) {
              setState(() {
                genreUsers = value;
              });
            },
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NButtonWidget(
                text: "Poursuivre",
                backColor: (nomKey.currentState != null && nomKey.currentState!.validate() && nomController.text.isNotEmpty) &&
                        (prenomKey.currentState != null && prenomKey.currentState!.validate() && prenomController.text.isNotEmpty)
                    ? null
                    : Colors.grey,
                action: () {
                  if ((nomKey.currentState!.validate() && nomController.text.isNotEmpty) &&
                      (prenomKey.currentState!.validate() && prenomController.text.isNotEmpty)) {
                    final user = Users();
                    user.nom = nomController.text.trim();
                    user.prenom = prenomController.text.trim();
                    user.genre = genreUsers.name;

                    onPageChanged(user);
                  } else {
                    NToastWidget().showToastStyle(
                      context,
                      message: "Veuillez renseigner les informations requis.",
                      alerteetat: ALERTEETAT.ATTENTION,
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _takePhoneAndVerify() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Veuillez fournir votre adresse e-mail ainsi que votre numéro de téléphone.",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          NTextInputWidget(
            textController: emailController,
            validationKey: emailKey,
            title: "Email",
            isRequired: true,
            leftIcon: Icons.mail,
            onChanged: (_) {
              emailKey.currentState!.validate();
              setState(() {});
            },
          ),
          NTextInputWidget(
            textController: phoneController,
            validationKey: phoneKey,
            isTelephone: true,
            title: "Téléphone",
            isRequired: true,
            codePays: initialPays?.code,
            codeTelephonique: codeTelephonique,
            getCodePays: (code) {
              setState(() {
                initialPays = listPays.firstWhere((element) => element.code == code);
              });
            },
            getCodeTelephone: (codeT) {
              setState(() {
                codeTelephonique = codeT;
              });
            },
            onChanged: (_) {
              phoneKey.currentState!.validate();
              setState(() {});
            },
          ),
          /*if (phoneKey.currentState != null && phoneKey.currentState!.validate() && verifyPhone == false)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              onPressed: () async {
                NToastWidget().showToastStyle(
                  context,
                  message: "Envoie du code en cours...",
                  alerteetat: ALERTEETAT.AVERTISSEMENT,
                  closeAutomatically: false,
                  showActionAsLoad: true,
                );
                await Api()
                    .sendOtp(phone: '${'${initialPays!.indicatif}' '${phoneController.text.trim()}'}')
                    .then((value) async {
                  if (value["send"]) {
                    setState(() {
                      verifyPhone = true;
                    });
                  }
                  ScaffoldMessenger.of(context).clearSnackBars();
                });
              },
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Envoyer le code",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Style.defaultTextStyle(textSize: 10.0),
                ),
              ),
            ),
          if (verifyPhone)
            NTextInputWidget(
              textController: otpController,
              validationKey: otpKey,
              title: "OTP",
              readOnly: codeSent,
              isRequired: true,
              onChanged: (_) {
                otpKey.currentState!.validate();
              },
            ),
          if (phoneKey.currentState != null && phoneKey.currentState!.validate() && verifyPhone)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              onPressed: () {},
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Valider",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Style.defaultTextStyle(textSize: 10.0),
                ),
              ),
            ),*/
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NButtonWidget(
                text: "Précédent",
                backColor: theme.colorScheme.secondary.withOpacity(.7),
                action: () {
                  pageController.previousPage(duration: Duration(milliseconds: 1500), curve: Curves.easeOut);
                },
              ),
              NButtonWidget(
                text: "Poursuivre",
                backColor: (emailKey.currentState != null && emailKey.currentState!.validate() && emailController.text.isNotEmpty) &&
                        (phoneKey.currentState != null &&
                            phoneKey.currentState!.validate() &&
                            phoneController.text.isNotEmpty) /*&&
                        isVerify*/
                    ? null
                    : Colors.grey,
                action: () {
                  if ((emailKey.currentState!.validate() && emailController.text.isNotEmpty) &&
                      (phoneKey.currentState!.validate() && phoneController.text.isNotEmpty)) {
                    final user = users;
                    user!.mail = emailController.text.trim();
                    user.telephone = phoneController.text.trim();
                    user.code_telephone = initialPays!.indicatif;

                    onPageChanged(user);
                    /*if (isVerify) {
                      final user = users;
                      user!.mail = emailController.text.trim();
                      user.telephone = phoneController.text.trim();

                      onPageChanged(user);
                    } else {
                      NToastWidget().showToastStyle(
                        context,
                        message: "Votre numéro de téléphone n'est pas vérifier",
                        alerteetat: ALERTEETAT.ATTENTION,
                      );
                    }*/
                  } else {
                    NToastWidget().showToastStyle(
                      context,
                      message: "Veuillez renseigner les informations requis.",
                      alerteetat: ALERTEETAT.ATTENTION,
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _adresseDataUser() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Veuillez renseigner les informations relatives à votre lieu de résidence.",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Vos informations doivent respecter les informations sur votre carte d'identité.",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          NTextInputWidget(
            textController: adresseController,
            validationKey: adresseKey,
            title: "Adresse",
            isRequired: true,
            leftIcon: Icons.location_on,
            onChanged: (_) {
              adresseKey.currentState!.validate();
              setState(() {});
            },
          ),
          NTextInputWidget(
            textController: quartierController,
            validationKey: quartierKey,
            title: "Quartier",
            isRequired: true,
            leftIcon: Icons.location_city,
            onChanged: (_) {
              quartierKey.currentState!.validate();
              setState(() {});
            },
          ),
          NTextInputWidget(
            textController: villeController,
            validationKey: villeKey,
            title: "Ville",
            isRequired: true,
            leftIcon: Icons.location_city,
            onChanged: (_) {
              villeKey.currentState!.validate();
              setState(() {});
            },
          ),
          NDropDownWidget(
            title: "Pays",
            initialObject: initialPays,
            listObjet: listPays,
            buildItem: (pays) {
              return NDropDownModelWidget(
                title: "${pays.nom}",
                imgLink: pays.url_drapeau,
              );
            },
            onChangedDropDownValue: (pays) {
              setState(() {
                initialPays = pays;
              });
            },
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NButtonWidget(
                text: "Précédent",
                backColor: theme.colorScheme.secondary.withOpacity(.7),
                action: () {
                  pageController.previousPage(duration: Duration(milliseconds: 1500), curve: Curves.easeOut);
                },
              ),
              NButtonWidget(
                text: "Poursuivre",
                backColor: (adresseKey.currentState != null && adresseKey.currentState!.validate() && adresseController.text.isNotEmpty) &&
                        (quartierKey.currentState != null && quartierKey.currentState!.validate() && quartierController.text.isNotEmpty) &&
                        (villeKey.currentState != null &&
                            villeKey.currentState!.validate() &&
                            villeController.text.isNotEmpty) /*&&
                        isVerify*/
                    ? null
                    : Colors.grey,
                action: () {
                  if ((adresseKey.currentState!.validate() && adresseController.text.isNotEmpty) &&
                      (quartierKey.currentState!.validate() && quartierController.text.isNotEmpty) &&
                      (villeKey.currentState!.validate() && villeController.text.isNotEmpty)) {
                    final user = users;
                    user!.adresse = adresseController.text.trim();
                    user.quartier = quartierController.text.trim();
                    user.ville = villeController.text.trim();
                    user.pays_id = initialPays!.id;

                    onPageChanged(user);
                  } else {
                    NToastWidget().showToastStyle(
                      context,
                      message: "Veuillez renseigner les informations requis.",
                      alerteetat: ALERTEETAT.ATTENTION,
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _connexionData() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Veuillez renseigner les informations de protection de votre compte.",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Sécurité renforcée à chaque connexion, protégez vos données avec des mots de passe inviolables.",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          NTextInputWidget(
            textController: passwordController,
            validationKey: passwordKey,
            title: "Mot de passe",
            leftIcon: Icons.password,
            mayObscureText: true,
            isRequired: true,
            isPassword: true,
            onChanged: (_) {
              passwordKey.currentState!.validate();
              setState(() {});
            },
          ),
          NTextInputWidget(
            textController: confirmPasswordController,
            validationKey: confirmPasswordKey,
            title: "Confirmer votre mot de passe",
            leftIcon: Icons.password,
            mayObscureText: true,
            isRequired: true,
            isPassword: true,
            onChanged: (_) {
              confirmPasswordKey.currentState!.validate();
              setState(() {});
            },
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NButtonWidget(
                text: "Précédent",
                backColor: theme.colorScheme.secondary.withOpacity(.7),
                action: () {
                  pageController.previousPage(duration: Duration(milliseconds: 1500), curve: Curves.easeOut);
                },
              ),
              NButtonWidget(
                text: "Poursuivre",
                backColor: (passwordKey.currentState != null && passwordKey.currentState!.validate() && passwordController.text.isNotEmpty) &&
                        (confirmPasswordKey.currentState != null &&
                            confirmPasswordKey.currentState!.validate() &&
                            confirmPasswordController.text.isNotEmpty) /*&&
                        isVerify*/
                    ? null
                    : Colors.grey,
                action: () {
                  if ((passwordKey.currentState!.validate() && passwordController.text.isNotEmpty) &&
                      (confirmPasswordKey.currentState!.validate() && confirmPasswordController.text.isNotEmpty)) {
                    if (passwordController.text == confirmPasswordController.text) {
                      final user = users;
                      user!.password = passwordController.text.trim();

                      onPageChanged(user);
                    } else {
                      NToastWidget().showToastStyle(
                        context,
                        message: "Vos mot de passe ne correspondent pas.",
                        alerteetat: ALERTEETAT.ERREUR,
                      );
                    }
                  } else {
                    NToastWidget().showToastStyle(
                      context,
                      message: "Veuillez renseigner les informations requis.",
                      alerteetat: ALERTEETAT.ATTENTION,
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _sendData() {
    return ListView(
      padding: EdgeInsets.all(12.0),
      children: <Widget>[
        SizedBox(height: 24.0),
        NExpandableWidget(
          title: "Nom",
          isExpanded: true,
          content: "${users == null ? "" : users!.nom}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 5.0),
        NExpandableWidget(
          title: "Prénom",
          isExpanded: true,
          content: "${users == null ? "" : users!.prenom}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 5.0),
        NExpandableWidget(
          title: "Genre",
          isExpanded: true,
          content: "${users == null ? "" : users!.genre}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 5.0),
        NExpandableWidget(
          title: "Email",
          isExpanded: true,
          content: "${users == null ? "" : users!.mail}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 5.0),
        NExpandableWidget(
          title: "Téléphone",
          isExpanded: true,
          content: "${users == null ? "" : users!.code_telephone}${users == null ? "" : users!.telephone}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 5.0),
        NExpandableWidget(
          title: "Adresse",
          isExpanded: true,
          content: "${users == null ? "" : users!.adresse}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 5.0),
        NExpandableWidget(
          title: "Quartier",
          isExpanded: true,
          content: "${users == null ? "" : users!.quartier}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 5.0),
        NExpandableWidget(
          title: "Ville",
          isExpanded: true,
          content: "${users == null ? "" : users!.ville}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 5.0),
        NExpandableWidget(
          title: "Pays",
          isExpanded: true,
          content: "${users == null ? "" : initialPays!.nom}",
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NButtonWidget(
              text: "Précédent",
              backColor: theme.colorScheme.secondary.withOpacity(.7),
              action: () {
                pageController.previousPage(duration: Duration(milliseconds: 1500), curve: Curves.easeOut);
              },
            ),
            NButtonWidget(
              text: "Valider",
              load: send,
              action: () async {
                setState(() {
                  send = true;
                });
                IpAddress ipAddress = IpAddress(type: RequestType.json);

                final ip = await ipAddress.getIpAddress();

                users!.ip_adresse = ip["ip"];

                Map<String, String> paramsSup = {
                  "action": "SAVE",
                };

                await Api.saveObjetApi(
                  arguments: users,
                  url: Url.UsersUrl,
                  additionalArgument: paramsSup,
                ).then(
                  (value) async {
                    if (value["saved"] == true) {
                      await Preferences().getUsersListFromLocal(id: value["inserted_id"]).then((user) async {
                        Preferences.saveData(key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
                        final user = await Preferences().getUsersListFromLocal(id: value["inserted_id"]).then((value) => value.first);
                        onPageChanged(user);
                        setState(() {
                          send = false;
                        });
                      });
                    } else if (value["message_error"] != null) {
                      setState(() {
                        send = false;
                      });
                      NToastWidget().showToastStyle(
                        context,
                        message: "${value["message_error"]}",
                        alerteetat: ALERTEETAT.ERREUR,
                      );
                    } else {
                      setState(() {
                        send = false;
                      });
                    }
                  },
                );
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _verifyAdresse() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Avant de pouvoir faire toute transaction, veuillez faire vérifier vos information en envoyant une preuve d'adresse et votre carte d'identité.",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Nous vous conseillons d'avoir une bonne connexion avant de pouvoir faire la vérification.",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            NCardWidget(
              margin: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    "Preuve d'Adresse",
                                    style: Style.defaultTextStyle(textWeight: FontWeight.w500, textSize: 12.0),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.pending_outlined,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    "Envoyez une photo de votre preuve d'Adresse. La preuve d'adresse peut être une Attestation de Résidence, une facture d'électricité ou un Relevé Bancaire.",
                                    style: Style.defaultTextStyle(
                                      textWeight: FontWeight.w300,
                                      textSize: 12.0,
                                      textOverflow: null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          NMediaWidget(
                            urlImage: "",
                            height: 200,
                            width: double.infinity,
                            imageQuality: 20,
                            isEditable: true,
                            isOtherImage: true,
                            backgroundColor: Colors.grey.shade50,
                            backgroundRadius: 0.0,
                            getNameImage: (value) {
                              setState(() {
                                adresseName = value;
                              });
                            },
                            getByte: (value) {
                              setState(() {
                                adresseByte = value;
                              });
                            },
                          ),
                          SizedBox(width: 12.0),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    "Pièce d'Identité",
                                    style: Style.defaultTextStyle(textWeight: FontWeight.w500, textSize: 12.0),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.pending_outlined,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    "Envoyez nous une photo de votre pièce d'identité, CIP ou Passeport pour la validation de votre compte.",
                                    style: Style.defaultTextStyle(
                                      textWeight: FontWeight.w300,
                                      textSize: 12.0,
                                      textOverflow: null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          NMediaWidget(
                            height: 200,
                            width: double.infinity,
                            imageQuality: 20,
                            isOtherImage: true,
                            isEditable: true,
                            backgroundColor: Colors.grey.shade50,
                            backgroundRadius: 0.0,
                            getNameImage: (value) {
                              setState(() {
                                cniName = value;
                              });
                            },
                            getByte: (value) {
                              setState(() {
                                cniByte = value;
                              });
                            },
                          ),
                          SizedBox(width: 12.0),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NButtonWidget(
                  text: "Ignorer",
                  backColor: theme.colorScheme.secondary.withOpacity(.7),
                  load: ignore,
                  action: () async {
                    setState(() {
                      ignore = true;
                    });
                    final user = users;
                    user!.statut = STATUT_USER.IS_NON_VERIFIER.name.toLowerCase();
                    user.type_user = TYPE_USER.USER.name.toLowerCase();
                    user.solde = "0";

                    Map<String, String> paramsSup = {
                      "action": "SAVE",
                      "send_notif": "1",
                    };

                    await Api.saveObjetApi(
                      arguments: user,
                      url: Url.UsersUrl,
                      additionalArgument: paramsSup,
                    ).then(
                      (value) async {
                        if (value["saved"] == true) {
                          await Preferences().getUsersListFromLocal(id: value["inserted_id"]).then((user) async {
                            Preferences.saveData(key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
                            Fonctions().openPageToGo(
                              context: context,
                              pageToGo: AppHomePage(users: user.first),
                              replacePage: true,
                            );
                            setState(() {
                              ignore = false;
                            });
                          });
                        } else if (value["message_error"] != null) {
                          setState(() {
                            ignore = false;
                          });
                          NToastWidget().showToastStyle(
                            context,
                            message: "${value["message_error"]}",
                            alerteetat: ALERTEETAT.ERREUR,
                          );
                        } else {
                          setState(() {
                            ignore = false;
                          });
                        }
                      },
                    );
                  },
                ),
                NButtonWidget(
                  text: "Valider",
                  load: send,
                  action: () async {
                    if ((adresseByte.isNotEmpty && cniByte.isNotEmpty)) {
                      setState(() {
                        send = true;
                      });

                      final user = users;

                      user!.statut = STATUT_USER.IS_NON_VERIFIER.name.toLowerCase();
                      user.type_user = TYPE_USER.USER.name.toLowerCase();
                      user.solde = "0";

                      Uri uri = Uri.https(Url.urlServer, Url.UsersUrl);

                      Map<String, String> adresseParams = {
                        'id': '${user.id}',
                        'type_image': 'adresse',
                        'action': 'SAVE_IMAGE',
                        'old_path': '',
                      };

                      Map<String, String> cniParams = {
                        'id': '${user.id}',
                        'type_image': 'cni',
                        'action': 'SAVE_IMAGE',
                        'old_path': '',
                      };

                      var requestAdresse = MultipartRequest('POST', uri);
                      requestAdresse.fields.addAll(adresseParams);
                      requestAdresse.files.add(http.MultipartFile.fromBytes('adresse', adresseByte, filename: adresseName));

                      var requestCni = MultipartRequest('POST', uri);
                      requestCni.fields.addAll(cniParams);
                      requestCni.files.add(http.MultipartFile.fromBytes('cni', cniByte, filename: cniName));

                      Map<String, String> paramsSup = {
                        "action": "SAVE",
                      };

                      await save(requestAdresse).then((adresse) async {
                        await save(requestCni).then((cni) async {
                          if (cni["saved"]) {
                            user.lien_cni = cni["lien"];
                            user.lien_adresse = adresse["lien"];

                            await Api.saveObjetApi(
                              arguments: user,
                              url: Url.UsersUrl,
                              additionalArgument: paramsSup,
                            ).then(
                              (value) async {
                                if (value["saved"] == true) {
                                  await Preferences().getUsersListFromLocal(id: value["inserted_id"]).then((user) async {
                                    Preferences.saveData(key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);

                                    Fonctions().showErrorAsWidget(
                                      context: context,
                                      message:
                                          "Vos informations seront vérifier par l'un de nos administrateur. Patientez en 1 et 3 jours. Une notification vous seras envoyer a la fin de la vérification.",
                                      assetPath: "assets/images/success.png",
                                      buttonText: "Allez à l'acceuil",
                                      action: () {
                                        Fonctions().openPageToGo(
                                          context: context,
                                          pageToGo: AppHomePage(users: user.first),
                                          replacePage: true,
                                        );
                                      },
                                      typewidgeterror: TYPEWIDGETERROR.BOTTOMSHEET,
                                    );
                                    setState(() {
                                      send = false;
                                    });
                                  });
                                } else if (value["message_error"] != null) {
                                  setState(() {
                                    send = false;
                                  });
                                  NToastWidget().showToastStyle(
                                    context,
                                    message: "${value["message_error"]}",
                                    alerteetat: ALERTEETAT.ERREUR,
                                  );
                                } else {
                                  setState(() {
                                    send = false;
                                  });
                                }
                              },
                            );
                          } else {
                            setState(() {
                              send = false;
                            });
                          }
                        });
                      });
                    } else {
                      NToastWidget().showToastStyle(
                        context,
                        message: "Veuillez choisir les images",
                        alerteetat: ALERTEETAT.ERREUR,
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> save(MultipartRequest request) async {
    try {
      http.StreamedResponse response = await request.send();
      var stream = await response.stream.bytesToString();

      print("url: ${request.url}\ncode: ${response.statusCode}\nbody: ${request.fields}\ncontent: $stream");
      if (response.statusCode == 200) {
        Map<String, dynamic> body = stream.isNotEmpty ? json.decode(stream) : {"codeReponse": "0"};
        print("body: $body");
        if (body["code"] == "100") {
          return {'saved': true, 'lien': body["lien"]};
        } else {
          return {'saved': false, 'lien': ""};
        }
      } else {
        print(response.reasonPhrase);
        return {'saved': false, 'lien': ""};
      }
    } catch (e) {
      print("error in catch: $e");
      return {'saved': false, 'lien': ""};
    }
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    String method,
    Uri url, {
    this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress!(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
