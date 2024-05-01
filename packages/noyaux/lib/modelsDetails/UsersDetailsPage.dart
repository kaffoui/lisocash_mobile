// ignore_for_file: must_be_immutable

import 'package:app/AppErrorCritiquePage.dart';
import 'package:flutter/material.dart';
import 'package:noyaux/pages/components/MyBodyPage.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_MediaWidget.dart';
import 'package:noyaux/widgets/N_ToastWidget.dart';

import '../constants/fonctions.dart';
import '../constants/styles.dart';
import '../models/Users.dart';
import '../pages/SplashScreenPage.dart';
import '../services/Preferences.dart';
import '../services/url.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DisplayImageWidget.dart';
import '../widgets/N_DisplayInfos.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';
import '../widgets/N_TextInputWidget.dart';

class UsersDetailsPage extends StatefulWidget {
  Users users;
  final bool showAppBar, mayGetOnline, skipLocalData;
  final Function? reloadParentList;

  UsersDetailsPage({
    super.key,
    required this.users,
    this.showAppBar = false,
    this.mayGetOnline = false,
    this.skipLocalData = false,
    this.reloadParentList,
  });

  @override
  State<UsersDetailsPage> createState() => _UsersDetailsPageState();
}

class _UsersDetailsPageState extends State<UsersDetailsPage> {
  Users? userconnected;

  late ThemeData theme;

  bool isLoading = false, getuserconnected = false;

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
    // print("Reload Users in Details Page");
    getUsers(skipLocal: true);
  }

  void getUsers({bool skipLocal = false}) async {
    setState(() {
      isLoading = true;
    });

    await Preferences(skipLocal: skipLocal)
        .getUsersListFromLocal(id: widget.users.id.toString())
        .then((value) => {
              setState(() async {
                widget.users = value.single;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                widget.users = Users();
                isLoading = false;
              })
            });
  }

  void getUsersConnected() async {
    setState(() {
      getuserconnected = true;
    });
    final idUsers = await Preferences().getIdUsers();
    if (idUsers.isNotEmpty) {
      userconnected = await Preferences().getUsersListFromLocal(id: idUsers).then((value) => value.first);
    }
    setState(() {
      getuserconnected = false;
    });
  }

  @override
  void initState() {
    getUsersConnected();
    if (widget.mayGetOnline == true) getUsers(skipLocal: widget.skipLocalData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
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
                text: "Détails Users".toUpperCase(),
                textColor: Colors.white,
                theme: BASE_TEXT_THEME.TITLE,
              ),
              centerTitle: true,
            )
          : null,
      body: Column(
        children: [
          if (isLoading) Expanded(child: Center(child: NLoadingWidget())),
          if (!isLoading && widget.users == Users())
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          userconnected != null && userconnected!.lien_pp!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                    "https://${Url.urlServer}/${Url.urlImageBase}/${userconnected != null ? userconnected!.lien_pp : ""}",
                                  ),
                                )
                              : NDisplayImageWidget(
                                  imageLink: "https://${Url.urlServer}/${Url.urlImageBase}/${userconnected != null ? userconnected!.lien_pp : ""}",
                                  size: 100,
                                  showDefaultImage: true,
                                  isRounded: true,
                                  isUserProfile: true,
                                ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          NDisplayTextWidget(
                            text: "${userconnected != null ? userconnected!.nom : ""} ${userconnected != null ? userconnected!.prenom : ""}",
                            theme: BASE_TEXT_THEME.TITLE_LARGE,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(width: 5.0),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      NDisplayInfos(
                        leftIcon: Icons.location_on_outlined,
                        title: 'Adresse',
                        content:
                            "${userconnected != null ? userconnected!.adresse : ""}, ${userconnected != null ? userconnected!.quartier : ""}, ${userconnected != null ? userconnected!.ville : ""}, ${userconnected != null ? userconnected!.pays!.nom : ""}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.mail_outline_outlined,
                        title: 'Email',
                        content: "${userconnected != null ? userconnected!.mail : ""}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.phone_outlined,
                        title: 'Téléphone',
                        content:
                            "${userconnected != null ? userconnected!.code_telephone : ""} ${userconnected != null ? userconnected!.telephone : ""}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.phone_outlined,
                        title: 'Whatsapp',
                        content:
                            "${userconnected != null ? userconnected!.code_whatsapp : ""} ${userconnected != null ? userconnected!.whatsapp : ""}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      if (!getuserconnected && userconnected != null)
                        NCardWidget(
                          margin: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(8.0),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  if (userconnected!.isAdresseValidated) Container(),
                                  if (!userconnected!.isAdresseValidated)
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
                                                userconnected!.isAdresseValidated ? Icons.check_circle_outline_outlined : Icons.pending_outlined,
                                                color: userconnected!.isAdresseValidated ? Colors.green : theme.colorScheme.secondary,
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
                                          urlImage:
                                              "https://${Url.urlServer}/${Url.urlImageBase}${userconnected == null ? "" : userconnected!.lien_adresse}",
                                          height: 200,
                                          width: double.infinity,
                                          imageQuality: 20,
                                          isOtherImage: true,
                                          backgroundColor: Colors.grey.shade50,
                                          backgroundRadius: 0.0,
                                          showButtonToSend: true,
                                          dataToSend: <String, dynamic>{},
                                          additionalArgument: {
                                            "action": "SAVE",
                                          },
                                          urlToSend: Url.UsersUrl,
                                          getBase64: (base64) {
                                            setState(() {});
                                          },
                                          onErrorImageSend: () {
                                            NToastWidget().showToastStyle(
                                              context,
                                              message: "L'envoie a échoué. Veullez reéssayer ou nous contacter.",
                                              alerteetat: ALERTEETAT.ERREUR,
                                            );
                                          },
                                          onSuccessImageSend: () async {
                                            await Preferences(skipLocal: true).getUsersListFromLocal(id: userconnected!.id.toString());
                                            NToastWidget().showToastStyle(
                                              context,
                                              message: "Votre preuve d'adresse a bien été envoyée",
                                              alerteetat: ALERTEETAT.SUCCES,
                                            );
                                          },
                                        ),
                                        SizedBox(width: 12.0),
                                      ],
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  if (userconnected!.isCniValidated) Container(),
                                  if (!userconnected!.isCniValidated)
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
                                                userconnected!.isAdresseValidated ? Icons.check_circle_outline_outlined : Icons.pending_outlined,
                                                color: userconnected!.isAdresseValidated ? Colors.green : theme.colorScheme.secondary,
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
                                          urlImage: "https://${Url.urlServer}/${Url.urlImageBase}${userconnected!.lien_cni}",
                                          height: 200,
                                          width: double.infinity,
                                          imageQuality: 20,
                                          isOtherImage: true,
                                          backgroundColor: Colors.grey.shade50,
                                          backgroundRadius: 0.0,
                                          showButtonToSend: true,
                                          dataToSend: <String, dynamic>{},
                                          additionalArgument: {
                                            "action": "SAVE",
                                          },
                                          urlToSend: Url.UsersUrl,
                                          getBase64: (base64) {
                                            setState(() {});
                                          },
                                          onErrorImageSend: () {
                                            NToastWidget().showToastStyle(
                                              context,
                                              message: "L'envoie a échoué. Veullez reéssayer ou nous contacter.",
                                              alerteetat: ALERTEETAT.ERREUR,
                                            );
                                          },
                                          onSuccessImageSend: () async {
                                            await Preferences(skipLocal: true).getUsersListFromLocal(id: userconnected!.id.toString());
                                            NToastWidget().showToastStyle(
                                              context,
                                              message: "Votre preuve d'adresse a bien été envoyée",
                                              alerteetat: ALERTEETAT.SUCCES,
                                            );
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
                      SizedBox(height: 8.0),
                      if (!getuserconnected && (userconnected != null && (userconnected!.isAdmin || userconnected!.isSuperAdmin)))
                        Column(
                          children: [
                            SizedBox(height: 8.0),
                            NDisplayInfos(
                              leftIcon: Icons.network_check_rounded,
                              title: 'Adresse IP',
                              content: "${userconnected!.ip_adresse}",
                              showAsCard: true,
                            ),
                            SizedBox(height: 8.0),
                            NDisplayInfos(
                              leftIcon: Icons.money_rounded,
                              title: 'Solde',
                              content: "${userconnected!.solde}",
                              showAsCard: true,
                            ),
                            SizedBox(height: 8.0),
                            NDisplayInfos(
                              leftIcon: Icons.password_rounded,
                              title: 'Code Secret',
                              content: "${userconnected!.code_secret}",
                              showAsCard: true,
                            ),
                            SizedBox(height: 8.0),
                            NDisplayInfos(
                              leftIcon: Icons.person_outline,
                              title: 'Statut',
                              content: "${userconnected!.statut}",
                              showAsCard: true,
                            ),
                            SizedBox(height: 8.0),
                            NDisplayInfos(
                              leftIcon: Icons.person_add_rounded,
                              title: 'Type',
                              content: "${userconnected!.type_user}",
                              showAsCard: true,
                            ),
                          ],
                        ),
                      if (!getuserconnected && (userconnected != null && userconnected!.isUser))
                        Row(
                          children: [
                            Expanded(
                              child: NButtonWidget(
                                text: "Modifier",
                                action: () {
                                  Fonctions().openPageToGo(
                                    context: context,
                                    pageToGo: Scaffold(
                                      appBar: AppBar(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0.0,
                                      ),
                                      backgroundColor: Colors.white,
                                      body: MyBodyPage(
                                        child: saveUsersForm(objectUsers: userconnected),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: NButtonWidget(
                                text: "Déconnexion",
                                action: () async {
                                  await Preferences.clearData().then((value) {
                                    Fonctions().openPageToGo(
                                      context: context,
                                      pageToGo: SplashScreenPage(),
                                      replacePage: true,
                                    );
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      if (!getuserconnected && (userconnected != null && userconnected!.isUser) && userconnected!.isNonVerifier)
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: NButtonWidget(
                                text: "Modifier les preuves",
                                action: () {
                                  Fonctions().openPageToGo(
                                    context: context,
                                    pageToGo: AppErrorCritiquePage(users: userconnected),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget saveUsersForm({Users? objectUsers}) {
    TextEditingController firstnameController = TextEditingController(text: objectUsers != null ? objectUsers.prenom ?? '' : null);
    TextEditingController lastnameController = TextEditingController(text: objectUsers != null ? objectUsers.nom ?? '' : null);
    TextEditingController emailController = TextEditingController(text: objectUsers != null ? objectUsers.mail ?? '' : null);
    TextEditingController adresseController = TextEditingController(text: objectUsers != null ? objectUsers.adresse ?? '' : null);
    TextEditingController quartierController = TextEditingController(text: objectUsers != null ? objectUsers.quartier ?? '' : null);
    TextEditingController villeController = TextEditingController(text: objectUsers != null ? objectUsers.quartier ?? '' : null);
    TextEditingController whatsappController = TextEditingController(text: objectUsers != null ? objectUsers.whatsapp ?? "" : null);
    TextEditingController telephoneController = TextEditingController(text: objectUsers != null ? objectUsers.telephone ?? "" : null);

    GlobalKey<FormFieldState> firstnameKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> lastnameKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> emailKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> adresseKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> quartierKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> villeKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> whatsappKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> telephoneKey = GlobalKey<FormFieldState>();

    bool isSend = false;

    String codeTelephone = objectUsers != null ? objectUsers.code_telephone ?? "+229" : "+229",
        codeWhatsapp = objectUsers != null ? objectUsers.whatsapp ?? "+229" : "+229";

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: 500,
          color: Colors.white,
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NTextInputWidget(
                textController: lastnameController,
                validationKey: lastnameKey,
                isRequired: true,
                title: "Nom(s)",
              ),
              NTextInputWidget(
                textController: firstnameController,
                validationKey: firstnameKey,
                isRequired: true,
                title: "Prénom(s)",
              ),
              NTextInputWidget(
                title: "Adresse",
                textController: adresseController,
                validationKey: adresseKey,
                isDate: true,
                isRequired: true,
              ),
              NTextInputWidget(
                title: "Quartier",
                textController: quartierController,
                validationKey: quartierKey,
                isRequired: true,
              ),
              NTextInputWidget(
                title: "Whatsapp",
                textController: whatsappController,
                validationKey: whatsappKey,
                codeTelephonique: codeWhatsapp,
                isTelephone: true,
                isRequired: true,
                getCodeTelephone: (value) {
                  setState(() {
                    codeWhatsapp = value;
                  });
                },
              ),
              NTextInputWidget(
                title: "Téléphone",
                textController: telephoneController,
                validationKey: telephoneKey,
                codeTelephonique: codeTelephone,
                isTelephone: true,
                isRequired: true,
                getCodeTelephone: (value) {
                  setState(() {
                    codeTelephone = value;
                  });
                },
              ),
              NTextInputWidget(
                title: "Email",
                textController: emailController,
                validationKey: emailKey,
                isEmail: true,
                isRequired: true,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: NButtonWidget(
                      text: "Enregistrer",
                      rounded: true,
                      margin: EdgeInsets.all(12),
                      load: isSend,
                      action: () async {
                        setState(() {
                          isSend = true;
                        });
                        final objectToSend = Users(
                          id: objectUsers != null ? objectUsers.id : null,
                          pays_id: objectUsers != null ? objectUsers.pays_id : null,
                          prenom: firstnameController.text.trim(),
                          nom: lastnameController.text.trim(),
                          mail: emailController.text.trim(),
                          quartier: quartierController.text.trim(),
                          ville: villeController.text.trim(),
                          adresse: adresseController.text.trim(),
                          password: objectUsers != null ? objectUsers.password : null,
                          code_secret: objectUsers != null ? objectUsers.code_secret : null,
                          code_telephone: codeTelephone,
                          code_whatsapp: codeWhatsapp,
                          fcm_token: objectUsers != null ? objectUsers.fcm_token : null,
                          genre: objectUsers != null ? objectUsers.genre : null,
                          ip_adresse: objectUsers != null ? objectUsers.ip_adresse : null,
                          is_adresse_validated: objectUsers != null ? objectUsers.is_adresse_validated : null,
                          is_cni_validated: objectUsers != null ? objectUsers.is_cni_validated : null,
                          lien_adresse: objectUsers != null ? objectUsers.lien_adresse : null,
                          lien_cni: objectUsers != null ? objectUsers.lien_cni : null,
                          solde: objectUsers != null ? objectUsers.solde : null,
                          statut: objectUsers != null ? objectUsers.statut : null,
                          telephone: telephoneController.text.trim(),
                          type_user: objectUsers != null ? objectUsers.type_user : null,
                          whatsapp: whatsappController.text.trim(),
                          lien_pp: objectUsers != null ? objectUsers.lien_pp : null,
                        );

                        Map<String, String> paramsSup = {
                          "action": "SAVE",
                        };

                        await Api.saveObjetApi(arguments: objectToSend, additionalArgument: paramsSup, url: Url.UsersUrl).then((value) {
                          if (value["saved"] == true) {
                            setState(() {
                              isSend = false;
                            });
                            Navigator.pop(context);
                            getUsersConnected();
                          } else {
                            setState(() {
                              isSend = false;
                            });
                          }
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
