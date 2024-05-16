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
import 'package:noyaux/widgets/N_MenuWidget.dart';

class AppHomePage extends StatefulWidget {
  final Users users;
  final int currentIndex;

  const AppHomePage({super.key, required this.users, this.currentIndex = 0});

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

  bool show_badge = false;

  List<DrawerItem> listItems = [];

  void setItems() {
    setState(() {
      listItems.addAll(
        [
          DrawerItem(
            iconData: MdiIcons.home,
            name: "Acceuil",
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
            name: "Notification",
            page: AppNotificationPage(
              user_id: widget.users.id.toString(),
            ),
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
              message_error: "Vous n'avez aucune validations aujourd'hui !",
            ),
            visible: true,
          ),
          DrawerItem(
            iconData: MdiIcons.faceManProfile,
            name: "Profile",
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
      if (widget.users.fcm_token != null) {
        if (widget.users.fcm_token!.isNotEmpty) {
          if (tokenUser != null) {
            if (tokenUser != widget.users.fcm_token) {
              final dataToSend = widget.users;
              dataToSend.fcm_token = tokenUser;

              Map<String, String> paramsSup = {
                "action": "SAVE",
              };
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
            }
          }
        } else {
          if (tokenUser != null) {
            final dataToSend = widget.users;
            dataToSend.fcm_token = tokenUser;

            Map<String, String> paramsSup = {
              "action": "SAVE",
            };
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
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.high,
    );

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print("message initial: $message");
      if (message != null) {
        setState(() {
          show_badge = true;
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
            show_badge = true;
          });
        }
      }

      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

      if (message.data.isNotEmpty) {
        if (currentIndex != 2) {
          setState(() {
            show_badge = true;
          });
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        if (currentIndex != 2) {
          setState(() {
            show_badge = true;
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
    Size size = MediaQuery.sizeOf(context);
    theme = Theme.of(context);
    return Scaffold(
      appBar: Fonctions().defaultAppBar(
        context: context,
        elevation: 0.0,
        centerTitle: true,
        leadingWidget: IconButton(
          icon: Icon(
            value == 0 ? Icons.menu : Icons.close,
            size: 20.0,
            color: theme.primaryColor,
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
            textSize: 20.0,
            textColor: theme.primaryColor,
            textWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Container(
              width: 250.0,
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...listItems
                            .map(
                              (e) => ListTile(
                                onTap: () {
                                  setState(() {
                                    currentIndex = listItems.indexOf(e);
                                    value = 0;
                                  });
                                },
                                leading: Icon(
                                  e.iconData,
                                ),
                                title: Text(
                                  "${e.name}",
                                  style: Style.defaultTextStyle(
                                    textColor: currentIndex == listItems.indexOf(e)
                                        ? Colors.black
                                        : Colors.black.withOpacity(.5),
                                  ),
                                ),
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
                child: listItems[currentIndex].page,
              ));
            },
          ),
        ],
      ) /*Container(
        color: Colors.white,
        child: ,
      )*/
      ,
      /*bottomNavigationBar: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(size.width * .05),
          height: size.width * .155,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView.builder(
            itemCount: listItems.length,
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: true,
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: size.width * .02),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  currentIndex = index;
                  if (index == 2) {
                    setState(() {
                      show_badge = false;
                    });
                  }
                  HapticFeedback.lightImpact();
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex ? size.width * .32 : size.width * .18,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: index == currentIndex ? size.width * .12 : 0,
                      width: index == currentIndex ? size.width * .32 : 0,
                      decoration: BoxDecoration(
                        color: index == currentIndex ? Colors.blueAccent.withOpacity(.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex ? size.width * .31 : size.width * .18,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == currentIndex ? size.width * .10 : 0,
                            ),
                            AnimatedOpacity(
                              opacity: index == currentIndex ? 1 : 0,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Text(
                                index == currentIndex ? '${listItems[index].name}' : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == currentIndex ? size.width * .02 : 20,
                            ),
                            Badge(
                              isLabelVisible: index == 2 && show_badge,
                              child: Icon(
                                listItems[index].iconData,
                                size: 16,
                                color: index == currentIndex ? theme.colorScheme.secondary : Colors.black26,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),*/
    );
  }
}
