import 'package:app/AppErrorCritiquePage.dart';
import 'package:app/AppHomePage.dart';
import 'package:app/AppLoginPage.dart';
import 'package:dashboard/DashboardHomePage.dart';
import 'package:dashboard/DashboardLoginPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';

import '../constants/fonctions.dart';
import '../services/Preferences.dart';
import '../services/api/Api.dart';
import '../services/url.dart';
import '../widgets/N_DisplayImageWidget.dart';
import '../widgets/N_LoadingWidget.dart';
import 'components/MyBodyPage.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool getusers = false, changeColor = false;

  void checkUsers() async {
    String id = await Preferences().getIdUsers();

    if (id.isNotEmpty) {
      final data = await Preferences().getUsersListFromLocal(id: id);
      final agents_data = await Preferences().getAgentsListFromLocal(id: id);

      if (agents_data.isNotEmpty) {
        setState(() {
          changeColor = true;
        });
      }

      if (data.isNotEmpty) {
        IpAddress ipAddress = IpAddress(type: RequestType.json);

        final ip = await ipAddress.getIpAddress();

        final users = data.first;
        users.ip_adresse = ip["ip"];

        /*final pays = await Fonctions().getPaysFromIp();

        final currency = await Api().fetchExchangeRate(users.pays?.symbole_monnaie, pays.symbole_monnaie);

        users.solde = "${double.tryParse("${int.parse(users.solde!) * currency.value!}")!.toStringAsFixed(0)}";*/

        Map<String, String> paramsSup = {
          "action": "SAVE",
        };

        await Api.saveObjetApi(arguments: users, url: Url.UsersUrl, additionalArgument: paramsSup).then(
          (value) {
            if (value["saved"] == true) {
              Preferences.removeData(key: "${Preferences.PREFS_KEY_UsersID}");
              Preferences.saveData(key: "${Preferences.PREFS_KEY_UsersID}", data: value["inserted_id"]);
              Fonctions().openPageToGo(
                context: context,
                pageToGo: (users.isAdmin || users.isSuperAdmin) && kIsWeb
                    ? DashboardHomePage()
                    : users.isVerifier || users.lien_adresse!.isNotEmpty || users.lien_cni!.isNotEmpty
                        ? AppHomePage(users: users)
                        : AppErrorCritiquePage(users: users),
                replacePage: true,
              );
            }
          },
        );
      } else {
        Fonctions().openPageToGo(
          context: context,
          pageToGo: kIsWeb ? DashboardLoginPage() : AppLoginPage(),
          replacePage: true,
        );
      }
    } else {
      Fonctions().openPageToGo(
        context: context,
        pageToGo: kIsWeb ? DashboardLoginPage() : AppLoginPage(),
        replacePage: true,
      );
    }
  }

  @override
  void initState() {
    checkUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyBodyPage(
      backColor: Colors.white,
      colorRound: changeColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NDisplayImageWidget(
            imageLink: 'assets/images/logo.png',
            size: 200,
          ),
          if (getusers)
            NLoadingWidget(
              width: 24,
              height: 24,
            ),
        ],
      ),
    );
  }
}
