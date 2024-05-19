import 'package:app/AppAcceuilPage.dart';
import 'package:app/AppNotificationPage.dart';
import 'package:app/AppStatsPage.dart';
import 'package:app/agents/AppAgentsHomePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Notifications.dart';
import 'package:noyaux/models/Pays.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/modelsDetails/UsersDetailsPage.dart';
import 'package:noyaux/modelsLists/OperationListWidget.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/firebase_services.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_DisplayImageWidget.dart';
import 'package:noyaux/widgets/N_DisplayTextWidget.dart';
import 'package:noyaux/widgets/N_MenuWidget.dart';

class AppHomePage extends StatefulWidget {
  final Users users;
  final int currentIndex;

  const AppHomePage({Key? key, required this.users, this.currentIndex = 0}) : super(key: key);

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int? currentIndex;
  int? currentSecondIndex;
  int? currentThirdIndex;

  Pays? _currentPaysUser;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  ScrollController scrollController = ScrollController();

  late ThemeData theme;

  double value = 0.0;

  Color backgroundColor = Constants.kPrimaryColor;

  bool showBadge = false;

  List<DrawerItem> listItems = [];
  List<DrawerItem> listSecondItems = [];
  List<DrawerItem> listThirdItems = [];

  void getPays() async {
    _currentPaysUser = await Fonctions().getPaysFromIp();
    setState(() {});
  }

  void setItems() {
    setState(() {
      listItems.addAll([
        DrawerItem(
          iconData: MdiIcons.home,
          name: "Accueil",
          page: AppAcceuilPage(),
          visible: true,
        ),
        DrawerItem(
          iconData: Icons.stacked_bar_chart,
          name: "Statistiques",
          page: AppStatsPage(),
          visible: true,
        ),
        DrawerItem(
          iconData: Icons.notifications,
          name: "Notifications",
          page: AppNotificationPage(user_id: widget.users.id.toString()),
          visible: true,
        ),
        DrawerItem(
          iconData: MdiIcons.transfer,
          name: "Validations",
          page: OperationListWidget(
            user_id: widget.users.id.toString(),
            showAsGrid: true,
            showItemAsCard: true,
            showValidation: true,
            message_error: "Vous n'avez aucune validation aujourd'hui !",
          ),
          visible: true,
        ),
        DrawerItem(
          iconData: MdiIcons.faceAgent,
          name: "Mon Compte Agent",
          page: AppAgentsHomePage(),
          visible: true,
        ),
      ]);

      listSecondItems.addAll([
        DrawerItem(
          iconData: MdiIcons.faceManProfile,
          name: "Profil",
          page: UsersDetailsPage(users: widget.users),
          visible: true,
        ),
      ]);

      listThirdItems.addAll([
        DrawerItem(
          iconData: MdiIcons.alertBoxOutline,
          name: "À propos de nous",
          page: UsersDetailsPage(users: widget.users),
          visible: true,
        ),
      ]);
    });
  }

  Future<void> _backgroundHandler(RemoteMessage message) async {
    print("message: $message");
  }

  void sendToken() async {
    final tokenUser = await FirebaseServices().getTokenUser();
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic("LISOCASH");
      if (widget.users.fcm_token != null && widget.users.fcm_token!.isNotEmpty) {
        if (tokenUser != null && tokenUser != widget.users.fcm_token) {
          final dataToSend = widget.users;
          dataToSend.fcm_token = tokenUser;

          Map<String, String> paramsSup = {"action": "SAVE"};
          await Api.saveObjetApi(
            arguments: dataToSend,
            additionalArgument: paramsSup,
            url: Url.UsersUrl,
          ).then((value) async {
            final notif = Notifications(
              titre: "${dataToSend.nom} ${dataToSend.prenom}",
              message: "Nous vous souhaitons la bienvenue sur Lisocash.",
              user_id: dataToSend.id,
              type_notification: "welcome",
              priorite: "normal",
            );

            await Api.saveObjetApi(
              arguments: notif,
              additionalArgument: {
                'action': 'SAVE',
                'send_notif': '1',
                'fcm_token': ['$tokenUser']
              },
              url: Url.NotificationsUrl,
            );

            Preferences(skipLocal: true).getUsersListFromLocal(id: widget.users.id.toString());
          });
        } else {
          if (tokenUser != null) {
            final dataToSend = widget.users;
            dataToSend.fcm_token = tokenUser;

            Map<String, String> paramsSup = {"action": "SAVE"};
            await Api.saveObjetApi(
              arguments: dataToSend,
              additionalArgument: paramsSup,
              url: Url.UsersUrl,
            ).then((value) async {
              final notif = Notifications(
                titre: "${widget.users.nom} ${widget.users.prenom}",
                message: "Nous vous souhaitons la bienvenue sur Lisocash.",
                user_id: widget.users.id,
                type_notification: "welcome",
                priorite: "normal",
              );

              await Api.saveObjetApi(
                arguments: notif,
                additionalArgument: {
                  'action': 'SAVE',
                  'send_notif': '1',
                  'fcm_token': '$tokenUser',
                },
                url: Url.NotificationsUrl,
              );

              Preferences(skipLocal: true).getUsersListFromLocal(id: widget.users.id.toString());
            });
          }
        }
      }
    }
  }

  void configureNotification() async {
    AndroidInitializationSettings("@mipmap/launcher_icon");
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'Notifications importantes',
      description: 'Ce canal est utilisé pour les notifications importantes.',
      importance: Importance.high,
    );

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print("message initial: $message");
      if (message != null) {
        setState(() {
          showBadge = true;
        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification!.android;
      if (notification != null && androidNotification != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/launcher_icon',
            ),
          ),
        );
        if (currentIndex != 2) {
          setState(() {
            showBadge = true;
          });
        }
      }

      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

      if (message.data.isNotEmpty) {
        if (currentIndex != 2) {
          setState(() {
            showBadge = true;
          });
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        if (currentIndex != 2) {
          setState(() {
            showBadge = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    setItems();
    currentIndex = widget.currentIndex;

    super.initState();
    getPays();
    configureNotification();
    sendToken();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: 280,
        color: backgroundColor,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white54,
                  child: NDisplayImageWidget(
                    imageLink:
                        "https://${Url.urlServer}/${Url.urlImageBase}/${widget.users.lien_pp}",
                    showDefaultImage: true,
                    isRounded: true,
                    isUserProfile: true,
                  ),
                ),
                title: NDisplayTextWidget(
                  text: "${widget.users.nom} ${widget.users.prenom}",
                  theme: BASE_TEXT_THEME.TITLE_SMALL,
                  textColor: Colors.white,
                ),
                subtitle: NDisplayTextWidget(
                  text:
                      "${widget.users.pays?.nom}${_currentPaysUser != null && _currentPaysUser != widget.users.pays ? "|" : ""}${_currentPaysUser != null && _currentPaysUser != widget.users.pays ? _currentPaysUser?.nom : ""}",
                  theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                  textColor: Colors.white,
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Actions",
                      style: Style.defaultTextStyle(
                        textSize: 12.0,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ...listItems.map(
                (items) => ListTile(
                  onTap: () {
                    setState(() {
                      currentIndex = listItems.indexOf(items);
                      currentSecondIndex = null;
                      currentThirdIndex = null;
                      if (currentIndex == 4) {
                        setState(() {
                          backgroundColor = theme.colorScheme.secondary;
                        });
                      } else {
                        setState(() {
                          backgroundColor = theme.primaryColor;
                        });
                      }
                    });
                  },
                  leading: Icon(
                    items.iconData,
                    size: 30.0,
                    color: currentIndex == listItems.indexOf(items)
                        ? Colors.white
                        : Colors.black.withOpacity(.5),
                  ),
                  title: Text(
                    "${items.name}",
                    style: Style.defaultTextStyle(
                      textColor: currentIndex == listItems.indexOf(items)
                          ? Colors.white
                          : Colors.black.withOpacity(.5),
                      textSize: currentIndex == listItems.indexOf(items) ? 14.0 : 12.0,
                      textWeight: currentIndex == listItems.indexOf(items)
                          ? FontWeight.w700
                          : FontWeight.w100,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Profil",
                      style: Style.defaultTextStyle(
                        textSize: 12.0,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ...listSecondItems.map(
                (items) => ListTile(
                  onTap: () {
                    setState(() {
                      currentSecondIndex = listSecondItems.indexOf(items);
                      currentIndex = null;
                      setState(() {
                        backgroundColor = theme.primaryColor;
                      });
                      currentThirdIndex = null;
                    });
                  },
                  leading: Icon(
                    items.iconData,
                    size: 30.0,
                    color: currentSecondIndex == listSecondItems.indexOf(items)
                        ? Colors.white
                        : Colors.black.withOpacity(.5),
                  ),
                  title: Text(
                    "${items.name}",
                    style: Style.defaultTextStyle(
                      textColor: currentSecondIndex == listSecondItems.indexOf(items)
                          ? Colors.white
                          : Colors.black.withOpacity(.5),
                      textSize: currentSecondIndex == listSecondItems.indexOf(items) ? 14.0 : 12.0,
                      textWeight: currentSecondIndex == listSecondItems.indexOf(items)
                          ? FontWeight.w700
                          : FontWeight.w100,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Application",
                      style: Style.defaultTextStyle(
                        textSize: 12.0,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ...listThirdItems.map(
                (items) => ListTile(
                  onTap: () {
                    setState(() {
                      currentThirdIndex = listThirdItems.indexOf(items);
                      currentIndex = null;
                      setState(() {
                        backgroundColor = theme.primaryColor;
                      });
                      currentSecondIndex = null;
                    });
                  },
                  leading: Icon(
                    items.iconData,
                    size: 30.0,
                    color: currentThirdIndex == listThirdItems.indexOf(items)
                        ? Colors.white
                        : Colors.black.withOpacity(.5),
                  ),
                  title: Text(
                    "${items.name}",
                    style: Style.defaultTextStyle(
                      textColor: currentThirdIndex == listThirdItems.indexOf(items)
                          ? Colors.white
                          : Colors.black.withOpacity(.5),
                      textSize: currentThirdIndex == listThirdItems.indexOf(items) ? 14.0 : 12.0,
                      textWeight: currentThirdIndex == listThirdItems.indexOf(items)
                          ? FontWeight.w700
                          : FontWeight.w100,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
