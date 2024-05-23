import 'package:app/AppAcceuilPage.dart';
import 'package:app/AppNotificationPage.dart';
import 'package:app/AppStatsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Notifications.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/modelsDetails/UsersDetailsPage.dart';
import 'package:noyaux/modelsLists/OperationListWidget.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/firebase_services.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_DisplayImageWidget.dart';
import 'package:noyaux/widgets/N_MenuWidget.dart';

class AppHomePage extends StatefulWidget {
  final Users users;
  final int currentIndex;

  const AppHomePage({Key? key, required this.users, this.currentIndex = 0}) : super(key: key);

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int currentIndex = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  ScrollController scrollController = ScrollController();

  late ThemeData theme;

  double value = 0.0;

  bool showBadge = false, isMenuOpen = false;

  List<DrawerItem> listItems = [];

  void setItems() {
    setState(() {
      listItems.addAll(
        [
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
            iconData: MdiIcons.faceManProfile,
            name: "Profil",
            page: UsersDetailsPage(users: widget.users),
            visible: true,
          ),
          DrawerItem(
            iconData: MdiIcons.alertBoxOutline,
            name: "À propos de nous",
            page: UsersDetailsPage(users: widget.users),
            visible: true,
          ),
        ],
      );
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
    configureNotification();
    sendToken();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Container(
              width: 250.0,
              padding: EdgeInsets.all(8.0),
              color: theme.primaryColor,
              child: Column(
                children: [
                  DrawerHeader(
                    child: Row(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                24.0,
                              ),
                            ),
                          ),
                          child: NDisplayImageWidget(
                            imageLink: "assets/images/logo_3.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...listItems
                            .map(
                              (e) => Stack(
                                children: [
                                  AnimatedPositioned(
                                    curve: Curves.easeIn,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 12.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          bottomLeft: Radius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                    height: 56,
                                    width: currentIndex == listItems.indexOf(e) ? 250 : 0,
                                    duration: Duration(
                                      milliseconds: 300,
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = listItems.indexOf(e);
                                        value = 0;
                                      });
                                    },
                                    leading: Icon(
                                      e.iconData,
                                      color: currentIndex == listItems.indexOf(e)
                                          ? theme.primaryColor
                                          : Colors.black.withOpacity(.5),
                                    ),
                                    title: Text(
                                      "${e.name}",
                                      style: Style.defaultTextStyle(
                                        textColor: currentIndex == listItems.indexOf(e)
                                            ? theme.primaryColor
                                            : Colors.black.withOpacity(.5),
                                        textSize:
                                            currentIndex == listItems.indexOf(e) ? 14.0 : 12.0,
                                        textWeight: currentIndex == listItems.indexOf(e)
                                            ? FontWeight.w700
                                            : FontWeight.w100,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            builder: (_, val, __) {
              return (Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, .001)
                  ..setEntry(0, 3, 200 * val),
                child: Scaffold(
                  appBar: Fonctions().defaultAppBar(
                    context: context,
                    elevation: 0.0,
                    centerTitle: true,
                    leadingWidget: IconButton(
                      icon: Icon(
                        value == 0 ? Icons.menu : Icons.close,
                        size: 20.0,
                      ),
                      onPressed: () {
                        setState(() {
                          value == 0 ? value = 1 : value = 0;
                        });
                      },
                    ),
                    titleWidget: Text(
                      "${listItems[currentIndex].name}",
                      style: Style.defaultTextStyle(
                        textSize: 18.0,
                        textWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  body: listItems[currentIndex].page,
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}
