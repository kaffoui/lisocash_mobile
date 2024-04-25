import 'dart:ui';

import 'package:app/AppHomePage.dart';
import 'package:app/AppSignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/pages/components/MyBodyPage.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_DisplayTextWidget.dart';
import 'package:noyaux/widgets/N_TextInputWidget.dart';
import 'package:noyaux/widgets/N_ToastWidget.dart';

import 'AppErrorCritiquePage.dart';

class AppLoginPage extends StatefulWidget {
  const AppLoginPage({super.key});

  @override
  State<AppLoginPage> createState() => _AppLoginPageState();
}

class _AppLoginPageState extends State<AppLoginPage> with TickerProviderStateMixin {
  bool connexion = false, changePassword = false, withPhone = false, connectedPhone = false;

  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      emailChangePasswordController = TextEditingController(),
      newPasswordController = TextEditingController(),
      confirmNewPasswordController = TextEditingController(),
      telephoneController = TextEditingController();
  GlobalKey<FormFieldState> emailKey = GlobalKey<FormFieldState>(),
      passwordKey = GlobalKey<FormFieldState>(),
      emailChangePasswordKey = GlobalKey<FormFieldState>(),
      newPasswordKey = GlobalKey<FormFieldState>(),
      confirmNewPasswordKey = GlobalKey<FormFieldState>(),
      telephoneKey = GlobalKey<FormFieldState>();

  late ThemeData theme;

  String codeTelephone = "+228";

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return MyBodyPage(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.all(24.0),
          color: Colors.white.withOpacity(.7),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Connectez-vous",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Bienvenue sur notre plateforme de transfert sécurisé.",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!withPhone)
                      NTextInputWidget(
                        textController: emailController,
                        validationKey: emailKey,
                        title: "Email",
                        backColor: Colors.white,
                        titleColor: Colors.white,
                        leftIcon: Icons.mail,
                        isRequired: true,
                        onChanged: (_) {
                          emailKey.currentState!.validate();
                        },
                      ),
                    if (!withPhone)
                      NTextInputWidget(
                        backColor: Colors.white,
                        textController: passwordController,
                        validationKey: passwordKey,
                        title: "Mot de passe",
                        titleColor: Colors.white,
                        leftIcon: Icons.password,
                        isPassword: true,
                        mayObscureText: true,
                        isRequired: true,
                      ),
                    if (withPhone)
                      NTextInputWidget(
                        backColor: Colors.white,
                        textController: telephoneController,
                        validationKey: telephoneKey,
                        title: "Téléphone",
                        codeTelephonique: codeTelephone,
                        titleColor: Colors.white,
                        isTelephone: true,
                        isRequired: true,
                      ),
                    if (!withPhone)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NButtonWidget(
                            text: "Se connecter",
                            load: connexion,
                            action: () async {
                              if (emailKey.currentState!.validate() && passwordKey.currentState!.validate()) {
                                setState(() {
                                  connexion = true;
                                });

                                final data = await Preferences().getUsersListFromLocal(
                                  mail: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );

                                if (data.isNotEmpty) {
                                  IpAddress ipAddress = IpAddress(type: RequestType.json);

                                  final ip = await ipAddress.getIpAddress();

                                  final users = data.first;
                                  users.ip_adresse = ip["ip"];

                                  Map<String, String> paramsSup = {
                                    "action": "SAVE",
                                  };

                                  await Api.saveObjetApi(arguments: users, url: Url.UsersUrl, additionalArgument: paramsSup).then(
                                    (value) async {
                                      if (value["saved"] == true) {
                                        await Preferences().getUsersListFromLocal(id: value["inserted_id"]).then((user) {
                                          Preferences.removeData(key: "${Preferences.PREFS_KEY_UsersID}");
                                          Preferences.saveData(key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
                                          setState(() {
                                            connexion = false;
                                          });
                                          if (user.first.isVerifier) {
                                            Fonctions().openPageToGo(
                                              context: context,
                                              pageToGo: AppHomePage(users: user.first),
                                              replacePage: true,
                                            );
                                          } else {
                                            Fonctions().openPageToGo(
                                              context: context,
                                              pageToGo: AppErrorCritiquePage(users: user.first),
                                              replacePage: true,
                                            );
                                          }
                                        });
                                      }
                                    },
                                  );
                                } else {
                                  setState(() {
                                    connexion = false;
                                  });
                                  NToastWidget().showToastStyle(
                                    context,
                                    message: "Vérifier vos informations et réessayer.",
                                    alerteetat: ALERTEETAT.ERREUR,
                                  );
                                }
                              } else {
                                emailKey.currentState!.validate();
                                passwordKey.currentState!.validate();
                              }
                            },
                          ),
                          NButtonWidget(
                            text: "Mot de passe oublié !",
                            isOutline: true,
                            textColor: theme.colorScheme.secondary,
                            backColor: theme.colorScheme.secondary,
                            action: () {
                              Fonctions().showWidgetAsDialog(
                                context: context,
                                widget: StatefulBuilder(builder: (ctt, setState) {
                                  return Container(
                                    width: 320,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        NTextInputWidget(
                                          hintLabel: "Votre Email",
                                          textController: emailChangePasswordController,
                                          isEmail: true,
                                          validationKey: emailChangePasswordKey,
                                        ),
                                        NTextInputWidget(
                                          hintLabel: "Nouveau mot de passe",
                                          textController: newPasswordController,
                                          isPassword: true,
                                          mayObscureText: true,
                                          validationKey: newPasswordKey,
                                        ),
                                        NTextInputWidget(
                                          hintLabel: "Confirmer mot de passe",
                                          textController: confirmNewPasswordController,
                                          isPassword: true,
                                          mayObscureText: true,
                                          validationKey: confirmNewPasswordKey,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: NButtonWidget(
                                                text: "D'accord",
                                                load: changePassword,
                                                action: () async {
                                                  if (emailChangePasswordController.text.isNotEmpty &&
                                                      newPasswordController.text.isNotEmpty &&
                                                      confirmNewPasswordController.text.isNotEmpty) {
                                                    if (newPasswordController.text == confirmNewPasswordController.text) {
                                                      setState(() {
                                                        changePassword = true;
                                                      });
                                                      Map<String, dynamic> params = {
                                                        "mail": emailChangePasswordController.text.trim(),
                                                        "new_password": newPasswordController.text.trim(),
                                                        "action": "UPDATE_PASSWORD",
                                                      };
                                                      print("ici");
                                                      await Api.saveObjetApi(arguments: params, url: Url.UsersUrl).then((value) {
                                                        if (value["saved"] == true) {
                                                          Navigator.pop(context);
                                                          setState(() {
                                                            changePassword = false;
                                                          });
                                                          NToastWidget().showToastStyle(
                                                            ctt,
                                                            message: "Mot de passe modifié avec succès.",
                                                            alerteetat: ALERTEETAT.SUCCES,
                                                          );
                                                        } else {
                                                          setState(() {
                                                            changePassword = false;
                                                          });
                                                          NToastWidget().showToastStyle(
                                                            ctt,
                                                            message: "Une erreur s'est produite.",
                                                            alerteetat: ALERTEETAT.ERREUR,
                                                          );
                                                        }
                                                      });
                                                    } else {
                                                      NToastWidget().showToastStyle(
                                                        context,
                                                        message: "Vos mot de passe ne correspondent pas.",
                                                        alerteetat: ALERTEETAT.ERREUR,
                                                      );
                                                    }
                                                  } else {
                                                    emailChangePasswordKey.currentState!.validate();
                                                    newPasswordKey.currentState!.validate();
                                                    confirmNewPasswordKey.currentState!.validate();
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                                title: "Mot de passe oublié",
                              );
                            },
                          ),
                        ],
                      ),
                    if (withPhone)
                      Row(
                        children: [
                          Expanded(
                            child: NButtonWidget(
                              text: "Se connecter",
                              load: connectedPhone,
                              action: () {
                                setState(() {
                                  connectedPhone = true;
                                });
                                setState(() {
                                  connectedPhone = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(),
                        ),
                        SizedBox(width: 5.0),
                        NDisplayTextWidget(
                          text: "Ou",
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: NButtonWidget(
                            text: "S'inscrire",
                            backColor: theme.colorScheme.secondary,
                            action: () {
                              Fonctions().openPageToGo(
                                context: context,
                                pageToGo: AppSignUpPage(),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                    /*Row(
                      children: [
                        Expanded(
                          child: NButtonWidget(
                            text: withPhone ? "Se connecter avec mon email" : "Se connecter avec telephone",
                            backColor: Colors.white,
                            textColor: theme.colorScheme.secondary,
                            action: () {
                              setState(() {
                                withPhone = !withPhone;
                              });
                            },
                          ),
                        ),
                      ],
                    )*/
                  ],
                ),
              ),
              /* Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NButtonWidget(
                      text: "S'inscrire",
                      backColor: theme.colorScheme.secondary,
                      action: () {
                        Fonctions().openPageToGo(
                          context: context,
                          pageToGo: AppSignUpPage(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),*/
            ],
          ),
        ),
      ),
    );
  }
}
