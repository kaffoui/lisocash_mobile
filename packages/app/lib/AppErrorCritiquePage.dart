import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/firebase_services.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_MediaWidget.dart';
import 'package:noyaux/widgets/N_ToastWidget.dart';

import 'AppHomePage.dart';

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

class AppErrorCritiquePage extends StatefulWidget {
  final Users? users;
  final bool showAppBar;

  const AppErrorCritiquePage({
    super.key,
    this.users,
    this.showAppBar = false,
  });

  @override
  State<AppErrorCritiquePage> createState() => _AppErrorCritiquePageState();
}

class _AppErrorCritiquePageState extends State<AppErrorCritiquePage> {
  late ThemeData theme;

  String adresseName = "", cniName = "";

  bool ignore = false, send = false;

  List<int> adresseByte = [], cniByte = [];

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: SafeArea(
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
                                urlImage:
                                    "https://${Url.urlServer}/${Url.urlImageBase}${widget.users != null ? widget.users!.lien_adresse : ""}",
                                height: 200,
                                width: double.infinity,
                                imageQuality: 20,
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
                                urlImage:
                                    "https://${Url.urlServer}/${Url.urlImageBase}${widget.users != null ? widget.users!.lien_cni : ""}",
                                height: 200,
                                width: double.infinity,
                                imageQuality: 20,
                                isOtherImage: true,
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
                        final user = widget.users;
                        user!.statut = STATUT_USER.IS_NON_VERIFIER.name.toLowerCase();
                        user.type_user = TYPE_USER.USER.name.toLowerCase();
                        user.fcm_token = await FirebaseServices().getTokenUser();

                        Map<String, String> paramsSup = {
                          "action": "SAVE",
                        };

                        await Api.saveObjetApi(
                          arguments: user,
                          url: Url.UsersUrl,
                          additionalArgument: paramsSup,
                        ).then(
                          (value) async {
                            if (value["saved"] == true) {
                              await Preferences().getUsersListFromLocal(id: value["inserted_id"]).then((user) async {
                                Preferences.saveData(
                                    key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
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
                        if ((adresseByte.isNotEmpty && cniByte.isNotEmpty) ||
                            widget.users!.lien_adresse!.isNotEmpty ||
                            widget.users!.lien_cni!.isNotEmpty) {
                          setState(() {
                            send = true;
                          });

                          final user = widget.users;

                          user!.statut = STATUT_USER.IS_NON_VERIFIER.name.toLowerCase();
                          user.type_user = TYPE_USER.USER.name.toLowerCase();
                          user.fcm_token = await FirebaseServices().getTokenUser();

                          Uri uri = Uri.https(Url.urlServer, Url.UsersUrl);

                          Map<String, String> adresseParams = {
                            'id': '${user.id}',
                            'type_image': 'adresse',
                            'action': 'SAVE_IMAGE',
                            'old_path': user.lien_adresse ?? "",
                          };

                          Map<String, String> cniParams = {
                            'id': '${user.id}',
                            'type_image': 'cni',
                            'action': 'SAVE_IMAGE',
                            'old_path': user.lien_cni ?? "",
                          };

                          var requestAdresse = MultipartRequest('POST', uri);
                          requestAdresse.fields.addAll(adresseParams);
                          requestAdresse.files
                              .add(http.MultipartFile.fromBytes('adresse', adresseByte, filename: adresseName));

                          var requestCni = MultipartRequest('POST', uri);
                          requestCni.fields.addAll(cniParams);
                          requestCni.files.add(http.MultipartFile.fromBytes('cni', cniByte, filename: cniName));

                          Map<String, String> paramsSup = {
                            "action": "SAVE",
                            "send_notif": "1",
                          };

                          await save(requestAdresse).then((adresse) async {
                            await save(requestCni).then((cni) async {
                              user.lien_adresse =
                                  (adresse["lien"] as String).isNotEmpty ? adresse["lien"] : widget.users!.lien_adresse;
                              user.lien_cni = (cni["lien"] as String).isNotEmpty ? cni["lien"] : widget.users!.lien_cni;
                              await Api.saveObjetApi(
                                arguments: user,
                                url: Url.UsersUrl,
                                additionalArgument: paramsSup,
                              ).then(
                                (value) async {
                                  if (value["saved"] == true) {
                                    await Preferences()
                                        .getUsersListFromLocal(id: value["inserted_id"])
                                        .then((user) async {
                                      Preferences.saveData(
                                          key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
                                      Fonctions().showErrorAsWidget(
                                        context: context,
                                        message:
                                            "Vos informations seront vérifier par l'un de nos administrateur. Patientez en 1 et 3 jours. Une notification vous seras envoyer a la fin de la vérification.",
                                        assetPath: "assets/images/default_image.png",
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
        ),
      ),
    );
  }
}
