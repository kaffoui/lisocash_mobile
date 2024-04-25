import 'package:flutter/material.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Notifications.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/widgets/N_ErrorWidget.dart';
import 'package:noyaux/widgets/N_LoadingWidget.dart';

class AppNotificationPage extends StatefulWidget {
  final String? user_id;
  const AppNotificationPage({super.key, this.user_id});

  @override
  State<AppNotificationPage> createState() => _AppNotificationPageState();
}

class _AppNotificationPageState extends State<AppNotificationPage> {
  List<Notifications> notificationList = [];
  bool loading = false;

  Future<void> getList() async {
    setState(() {
      loading = true;
    });
    await Preferences().getNotificationsListFromLocal(user_id: widget.user_id).then((value) {
      notificationList.clear();
      notificationList.addAll(value);
      print("noti: $notificationList");
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: NLoadingWidget(),
            )
          : notificationList.isNotEmpty
              ? SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: notificationList
                          .map(
                            (e) => Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "${e.message}",
                                    style: Style.defaultTextStyle(textSize: 12.0),
                                    overflow: null,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "${Fonctions().displayDate(e.date_enregistrement!)}",
                                        style: Style.defaultTextStyle(
                                            textSize: 10.0, textStyle: FontStyle.italic, textWeight: FontWeight.w200),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : NErrorWidget(message: "Vous n'avez aucune notifications"),
    );
  }
}
