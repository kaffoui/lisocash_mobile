import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/pages/components/MyBodyPage.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_DisplayImageWidget.dart';
import 'package:noyaux/widgets/N_TextInputWidget.dart';
import 'package:noyaux/widgets/N_ToastWidget.dart';

import 'DashboardHomePage.dart';

class DashboardLoginPage extends StatefulWidget {
  const DashboardLoginPage({super.key});

  @override
  State<DashboardLoginPage> createState() => _DashboardLoginPageState();
}

class _DashboardLoginPageState extends State<DashboardLoginPage> {
  bool connexion = false;

  TextEditingController emailController = TextEditingController(), passwordController = TextEditingController();
  GlobalKey<FormFieldState> emailKey = GlobalKey<FormFieldState>(), passwordKey = GlobalKey<FormFieldState>();

  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return MyBodyPage(
      child: Container(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            height: 520,
            width: 520,
            child: NCardWidget(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  NDisplayImageWidget(
                    imageLink: "assets/images/logo.png",
                    size: 100,
                  ),
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
                          "Bienvenue sur notre plateforme administartive.",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  NTextInputWidget(
                    textController: emailController,
                    validationKey: emailKey,
                    title: "Email",
                    backColor: Colors.white,
                    titleColor: Colors.white,
                    leftIcon: Icons.mail,
                    isRequired: true,
                    onChanged: (_) {},
                  ),
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
                    onChanged: (_) {},
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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

                              await Api.saveObjetApi(
                                arguments: users,
                                url: Url.UsersUrl,
                                additionalArgument: paramsSup,
                              ).then(
                                (value) async {
                                  if (value["saved"] == true) {
                                    await Preferences().getUsersListFromLocal(id: value["inserted_id"]).then((user) {
                                      Preferences.removeData(key: "${Preferences.PREFS_KEY_UsersID}");
                                      Preferences.saveData(key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
                                      setState(() {
                                        connexion = false;
                                      });
                                      Fonctions().openPageToGo(
                                        context: context,
                                        pageToGo: DashboardHomePage(),
                                        replacePage: true,
                                      );
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(24.0),
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
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Bienvenue sur notre plateforme administartive.",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
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
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NTextInputWidget(
                  textController: emailController,
                  validationKey: emailKey,
                  title: "Email",
                  backColor: Colors.white,
                  titleColor: Colors.white,
                  leftIcon: Icons.mail,
                  isRequired: true,
                ),
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

                            await Api.saveObjetApi(arguments: users, url: Url.UsersUrl, additionalArgument: paramsSup)
                                .then(
                              (value) async {
                                if (value["saved"] == true) {
                                  await Preferences().getUsersListFromLocal(id: value["inserted_id"]).then((user) {
                                    Preferences.removeData(key: "${Preferences.PREFS_KEY_UsersID}");
                                    Preferences.saveData(
                                        key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
                                    setState(() {
                                      connexion = false;
                                    });
                                    Fonctions().openPageToGo(
                                      context: context,
                                      pageToGo: DashboardHomePage(),
                                      replacePage: true,
                                    );
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
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
*/
