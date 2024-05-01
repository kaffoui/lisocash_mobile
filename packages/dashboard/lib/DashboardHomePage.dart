import 'package:dashboard/DashboardFraisPage.dart';
import 'package:dashboard/DashboardOperationPage.dart';
import 'package:dashboard/DashboardPaysPage.dart';
import 'package:dashboard/DashboardTauxPage.dart';
import 'package:dashboard/DashboardUsersPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/models/Notifications.dart';
import 'package:noyaux/pages/SplashScreenPage.dart';
import 'package:noyaux/pages/components/MyBodyPage.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/firebase_services.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_DisplayTextWidget.dart';
import 'package:noyaux/widgets/N_MenuWidget.dart';

class DashboardHomePage extends StatefulWidget {
  final int selectedPageIndex;
  final bool menuCollapsed;

  const DashboardHomePage({
    super.key,
    this.selectedPageIndex = 0,
    this.menuCollapsed = false,
  });

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late PreferredSize globalAppBar;
  late ThemeData theme;
  int currentMenuIndex = 0;
  bool menuCollapsed = false;
  late NMenuWidget myMenuWidget;
  List<DrawerItem> menuItemsList = [];

  getDrawerItems() {
    setState(() {
      menuItemsList = [
        DrawerItem(
          iconData: Icons.groups_rounded,
          name: "Tous les utilisateurs",
          page: DashboardUsersPages(),
          visible: true,
          mayShowParentAppBar: true,
        ),
        DrawerItem(
          iconData: Icons.transfer_within_a_station_rounded,
          name: "Toutes les transactions",
          page: DashboardOperationPages(),
          visible: true,
          mayShowParentAppBar: true,
        ),
        DrawerItem(
          iconData: Icons.currency_exchange_rounded,
          name: "Tous les frais",
          page: DashboardFraisPages(),
          visible: true,
          mayShowParentAppBar: true,
        ),
        DrawerItem(
          iconData: Icons.flag_rounded,
          name: "Tous les pays",
          page: DashboardPaysPages(),
          visible: true,
          mayShowParentAppBar: true,
        ),
        DrawerItem(
          iconData: Icons.change_circle_rounded,
          name: "Tous les taux",
          page: DashboardTauxPages(),
          visible: true,
          mayShowParentAppBar: true,
        ),
        /*DrawerItem(
          iconData: Icons.settings_rounded,
          name: "Toutes les configurations",
          page: DashboardConfigurationPages(),
          visible: true,
          mayShowParentAppBar: true,
        ),*/
        DrawerItem(
          iconData: Icons.logout,
          name: "Déconnexion",
          visible: true,
          mayShowParentAppBar: false,
        ),
      ];
    });
  }

  void sendToken() async {
    await Preferences().getIdUsers().then((id) async {
      await Preferences().getUsersListFromLocal(id: id).then((value) async {
        final tokenUser = await FirebaseServices().getTokenUser();
        if (value.first.fcm_token != null) {
          if (value.first.fcm_token!.isNotEmpty) {
            if (tokenUser != null) {
              if (tokenUser != value.first.fcm_token) {
                final dataToSend = value.first;
                dataToSend.fcm_token = tokenUser;

                Map<String, String> paramsSup = {
                  "action": "SAVE",
                };
                await Api.saveObjetApi(
                  arguments: dataToSend,
                  additionalArgument: paramsSup,
                  url: Url.UsersUrl,
                ).then((value) async {
                  Preferences(skipLocal: true).getUsersListFromLocal(id: id);
                });
              }
            }
          } else {
            if (tokenUser != null) {
              final dataToSend = value.first;
              dataToSend.fcm_token = tokenUser;

              Map<String, String> paramsSup = {
                "action": "SAVE",
              };
              await Api.saveObjetApi(
                arguments: dataToSend,
                additionalArgument: paramsSup,
                url: Url.UsersUrl,
              ).then((value) async {
                Preferences(skipLocal: true).getUsersListFromLocal(id: id);
              });
            }
          }
        } else {
          if (tokenUser != null) {
            final dataToSend = value.first;
            dataToSend.fcm_token = tokenUser;

            Map<String, String> paramsSup = {
              "action": "SAVE",
            };
            await Api.saveObjetApi(
              arguments: dataToSend,
              additionalArgument: paramsSup,
              url: Url.UsersUrl,
            ).then((value) async {
              Preferences(skipLocal: true).getUsersListFromLocal(id: id);
            });
          }
        }
        if (tokenUser != null) {
          final dataToSend = value.first;
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
            Preferences(skipLocal: true).getUsersListFromLocal(id: id);
          });
        }
      });
    });
  }

  @override
  void initState() {
    currentMenuIndex = widget.selectedPageIndex;
    menuCollapsed = widget.menuCollapsed;
    getDrawerItems();
    myMenuWidget = NMenuWidget(
      customHeader: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo.png",
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      orientation: Axis.vertical,
      itemList: menuItemsList,
      backColor: Constants.kPrimaryColor,
      iconActiveColor: Colors.white,
      iconNonActiveColor: Constants.kAccentColor,
      currentIndex: currentMenuIndex,
      isCollapsed: menuCollapsed,
      onMenuCollapseChange: (collapsed) {
        setState(() {
          menuCollapsed = collapsed;
        });
      },
      onTap: (item) {
        final ancientIndex = currentMenuIndex;
        setState(() {
          if (item != menuItemsList.length - 1) {
            currentMenuIndex = item;
            Fonctions().openPageToGo(
              context: context,
              replacePage: true,
              pageToGo: DashboardHomePage(
                selectedPageIndex: item,
                menuCollapsed: menuCollapsed,
                // admins: widget.admins,
              ),
            );
          } else {
            Fonctions().showWidgetAsDialog(
              context: context,
              widget: StatefulBuilder(
                builder: (ctt, setState) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: NDisplayTextWidget(
                              text: "Etes-vous sûr de vouloir vous déconnecter ?",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          NButtonWidget(
                            text: "Oui",
                            action: () async {
                              await Preferences.clearData().then((value) {
                                Fonctions().openPageToGo(
                                    context: context,
                                    pageToGo: SplashScreenPage(),
                                    replacePage: true);
                              });
                            },
                          ),
                          SizedBox(width: 5.0),
                          NButtonWidget(
                            text: "Non",
                            backColor: Constants.kAccentColor,
                            action: () {
                              setState(() {
                                currentMenuIndex = ancientIndex;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          }
        });
      },
    );

    super.initState();
    sendToken();
  }

  @override
  Widget build(BuildContext context) {
    globalAppBar = Fonctions().defaultAppBar(
      context: context,
      elevation: 0,
      tailleAppBar: 64,
      titre: menuItemsList[currentMenuIndex].name,
      iconColor: Constants.kPrimaryColor,
      scaffoldKey: scaffoldKey,
      isNotRoot: Fonctions().isSmallScreen(context),
      leadingWidget: !Fonctions().isSmallScreen(context) ? Container() : null,
    );
    return MyBodyPage(
      child: Scaffold(
        key: scaffoldKey,
        appBar: Fonctions().isSmallScreen(context) ? globalAppBar : null,
        drawer: Fonctions().isSmallScreen(context) ? myMenuWidget : null,
        body: Row(
          children: [
            if (!Fonctions().isSmallScreen(context))
              Container(width: menuCollapsed ? 80 : 220, child: myMenuWidget),
            Expanded(
              child: Column(
                children: [
                  if (!Fonctions().isSmallScreen(context) &&
                      menuItemsList[currentMenuIndex].mayShowParentAppBar == true)
                    globalAppBar,
                  if (menuItemsList[currentMenuIndex].page != null)
                    Expanded(
                      child: MaterialApp(
                        title: Constants.kTitleApplication,
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(
                          primaryColor: Constants.kPrimaryColor,
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: Constants.kAccentColor,
                            secondary: Constants.kSecondColor,
                            background: Colors.white,
                          ),
                          useMaterial3: true,
                          iconTheme: IconThemeData(color: Colors.white),
                          appBarTheme: AppBarTheme(elevation: 0.0, color: Constants.kAccentColor),
                          scaffoldBackgroundColor: Colors.white,
                          dividerColor: Constants.kPrimaryColor,
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          textTheme: Theme.of(context).textTheme.apply(
                                bodyColor: Constants.kTextDefaultColor,
                                displayColor: Constants.kTextDefaultColor,
                                fontFamily: GoogleFonts.aBeeZee().fontFamily,
                              ),
                        ),
                        home: menuItemsList[currentMenuIndex].page!,
                        localizationsDelegates: [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: [
                          Locale('fr', ''),
                          Locale('en', ''),
                        ],
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
