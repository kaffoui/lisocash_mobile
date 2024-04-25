import 'package:flutter/material.dart';
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Notifications.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/modelsLists/UsersListWidget.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';
import 'package:noyaux/widgets/N_CardWidget.dart';
import 'package:noyaux/widgets/N_DisplayImageWidget.dart';
import 'package:noyaux/widgets/N_DisplayInfos.dart';
import 'package:noyaux/widgets/N_DisplayTextWidget.dart';
import 'package:noyaux/widgets/N_MediaWidget.dart';
import 'package:noyaux/widgets/N_ResponsiveWidget.dart';

class DashboardUsersPages extends StatefulWidget {
  const DashboardUsersPages({super.key});

  @override
  State<DashboardUsersPages> createState() => _DashboardUsersPagesState();
}

class _DashboardUsersPagesState extends State<DashboardUsersPages> {
  Users? users;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(12),
          child: NResponsiveWidget(
            largeScreen: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: NCardWidget(
                    margin: EdgeInsets.zero,
                    child: _UsersListBloc(
                      onItemPressed: (value) {
                        setState(() {
                          users = value;
                        });
                      },
                    ),
                  ),
                ),
                if (users != null && users!.id != null)
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: NCardWidget(
                            margin: EdgeInsets.zero,
                            child: UsersDetailsAdmin(
                              key: ValueKey<String>(users.toString()),
                              users: users!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            smallScreen: _UsersListBloc(showAsGrid: true),
          ),
        ),
      ),
    );
  }

  Widget _UsersListBloc({Key? key, bool showAsGrid = false, Function(Users users)? onItemPressed}) {
    return UsersListWidget(
      showItemAsCard: false,
      canEditItem: false,
      canAddItem: false,
      press: true,
      canDeleteItem: true,
      padding: EdgeInsets.all(12),
      showAsGrid: showAsGrid,
      showSearchBar: true,
      onItemPressed: onItemPressed != null
          ? (value) {
              onItemPressed(value);
            }
          : null,
    );
  }
}

class UsersDetailsAdmin extends StatefulWidget {
  final Users users;
  const UsersDetailsAdmin({super.key, required this.users});

  @override
  State<UsersDetailsAdmin> createState() => _UsersDetailsAdminState();
}

class _UsersDetailsAdminState extends State<UsersDetailsAdmin> {
  late ThemeData theme;

  bool validate_preuves = false;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Column(
      children: <Widget>[
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
                      widget.users.lien_pp!.isNotEmpty
                          ? CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                "https://${Url.urlServer}/${Url.urlImageBase}/${widget.users.lien_pp}",
                              ),
                            )
                          : NDisplayImageWidget(
                              imageLink: "https://${Url.urlServer}/${Url.urlImageBase}/${widget.users.lien_pp}",
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
                        text: "${widget.users.nom} ${widget.users.prenom}",
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
                    content: "${widget.users.adresse}, ${widget.users.quartier}, ${widget.users.ville}, ${widget.users.pays!.nom}",
                    showAsCard: true,
                  ),
                  SizedBox(height: 8.0),
                  NDisplayInfos(
                    leftIcon: Icons.mail_outline_outlined,
                    title: 'Email',
                    content: "${widget.users.mail}",
                    showAsCard: true,
                  ),
                  SizedBox(height: 8.0),
                  NDisplayInfos(
                    leftIcon: Icons.phone_outlined,
                    title: 'Téléphone',
                    content: "${widget.users.code_telephone} ${widget.users.telephone}",
                    showAsCard: true,
                  ),
                  SizedBox(height: 8.0),
                  NDisplayInfos(
                    leftIcon: Icons.phone_outlined,
                    title: 'Whatsapp',
                    content: "${widget.users.code_whatsapp} ${widget.users.whatsapp}",
                    showAsCard: true,
                  ),
                  SizedBox(height: 8.0),
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
                                        widget.users.isAdresseValidated ? Icons.check_circle_outline_outlined : Icons.pending_outlined,
                                        color: widget.users.isAdresseValidated ? Colors.green : theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                NMediaWidget(
                                  urlImage: "https://${Url.urlServer}/${Url.urlImageBase}${widget.users.lien_adresse}",
                                  height: 200,
                                  width: double.infinity,
                                  imageQuality: 20,
                                  isOtherImage: true,
                                  backgroundColor: Colors.grey.shade50,
                                  backgroundRadius: 0.0,
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
                                        widget.users.isAdresseValidated ? Icons.check_circle_outline_outlined : Icons.pending_outlined,
                                        color: widget.users.isAdresseValidated ? Colors.green : theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                NMediaWidget(
                                  urlImage: "https://${Url.urlServer}/${Url.urlImageBase}${widget.users.lien_cni}",
                                  height: 200,
                                  width: double.infinity,
                                  imageQuality: 20,
                                  isOtherImage: true,
                                  backgroundColor: Colors.grey.shade50,
                                  backgroundRadius: 0.0,
                                ),
                                SizedBox(width: 12.0),
                                if (!widget.users.isCniValidated && !widget.users.isAdresseValidated)
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        NButtonWidget(
                                          text: "Valider les preuves",
                                          load: validate_preuves,
                                          action: () async {
                                            setState(() {
                                              validate_preuves = true;
                                            });
                                            final user = widget.users;
                                            user.is_cni_validated = "1";
                                            user.is_adresse_validated = "1";
                                            user.statut = STATUT_USER.IS_VERIFIER.name.toLowerCase();

                                            Map<String, dynamic> paramSup = {
                                              "action": "SAVE",
                                            };

                                            await Api.saveObjetApi(
                                              arguments: user,
                                              url: Url.UsersUrl,
                                              additionalArgument: paramSup,
                                            ).then((value) async {
                                              final notif = Notifications(
                                                titre: "${user.nom} ${user.prenom}",
                                                message: "Vos preuves sont validés. Vous pouvez effectué des transactions.",
                                                user_id: user.id,
                                                type_notification: "transaction",
                                                priorite: "normal",
                                              );

                                              await Api.saveObjetApi(
                                                arguments: notif,
                                                additionalArgument: {
                                                  'action': 'SAVE',
                                                  'send_notif': '1',
                                                  'fcm_token': ['${user.fcm_token}']
                                                },
                                                url: Url.NotificationsUrl,
                                              );
                                            });
                                            setState(() {
                                              validate_preuves = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(width: 10.0),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    children: [
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.network_check_rounded,
                        title: 'Adresse IP',
                        content: "${widget.users.ip_adresse}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.money_rounded,
                        title: 'Solde',
                        content: "${widget.users.solde} ${widget.users.pays!.symbole_monnaie}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      NDisplayInfos(
                        leftIcon: Icons.password_rounded,
                        title: 'Code Secret',
                        content: "${widget.users.code_secret}",
                        showAsCard: true,
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            child: NDisplayInfos(
                              leftIcon: Icons.person_outline,
                              title: 'Statut',
                              content:
                                  "${widget.users.isVerifier ? "Vérifier" : widget.users.isNonVerifier ? "Non vérifier" : widget.users.isBlacklisted ? "Blocage" : widget.users.isRedlisted ? "Blocage critique" : ""}",
                              showAsCard: true,
                            ),
                          ),
                          NButtonWidget(
                            text: "Modifier",
                            action: () {
                              Fonctions().showWidgetAsDialog(
                                context: context,
                                widget: changeTypeUser(),
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            child: NDisplayInfos(
                              leftIcon: Icons.person_add_rounded,
                              title: 'Type',
                              content:
                                  "${widget.users.isUser ? "Utilisateur" : widget.users.isAdmin ? "Administrateur" : widget.users.isSuperAdmin ? "Super Admin" : widget.users.isAgent ? "Agent" : widget.users.isDistributeur ? "Distributeur" : ""}",
                              showAsCard: true,
                            ),
                          ),
                          NButtonWidget(
                            text: "Modifier",
                            action: () {
                              Fonctions().showWidgetAsDialog(
                                context: context,
                                widget: changeStatusUser(),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget changeStatusUser() {
  return Container(
    width: 500,
    child: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
        );
      },
    ),
  );
}

Widget changeTypeUser() {
  return Container(
    width: 500,
    child: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
        );
      },
    ),
  );
}
