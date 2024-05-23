import 'package:dashboard_agents/DashboardAgentsHomePage.dart';
import 'package:dashboard_agents/DashboardAgentsLoginPage.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';

import '../constants/fonctions.dart';
import '../services/Preferences.dart';
import '../services/api/Api.dart';
import '../services/url.dart';
import '../widgets/N_DisplayImageWidget.dart';
import '../widgets/N_LoadingWidget.dart';
import 'components/MyBodyPage.dart';

class SplashScreenAgentsPage extends StatefulWidget {
  const SplashScreenAgentsPage({super.key});

  @override
  State<SplashScreenAgentsPage> createState() => _SplashScreenAgentsPageState();
}

class _SplashScreenAgentsPageState extends State<SplashScreenAgentsPage> {
  bool getusers = false;

  void checkAgents() async {
    String id = await Preferences().getIdAgents();

    if (id.isNotEmpty) {
      final data = await Preferences().getAgentsListFromLocal(id: id);

      if (data.isNotEmpty) {
        IpAddress ipAddress = IpAddress(type: RequestType.json);

        final ip = await ipAddress.getIpAddress();

        final agents = data.first;
        agents.ip_adresse = ip["ip"];

        /*final pays = await Fonctions().getPaysFromIp();

        final currency = await Api().fetchExchangeRate(users.pays?.symbole_monnaie, pays.symbole_monnaie);

        users.solde = "${double.tryParse("${int.parse(users.solde!) * currency.value!}")!.toStringAsFixed(0)}";*/

        Map<String, String> paramsSup = {
          "action": "SAVE",
        };

        await Api.saveObjetApi(arguments: agents, url: Url.AgentsUrl, additionalArgument: paramsSup).then(
          (value) {
            if (value["saved"] == true) {
              Preferences.removeData(key: "${Preferences.PREFS_KEY_AgentsID}");
              Preferences.saveData(key: "${Preferences.PREFS_KEY_AgentsID}", data: value["inserted_id"]);
              Fonctions().openPageToGo(
                context: context,
                pageToGo: DashboardAgentsHomePage(),
                replacePage: true,
              );
            }
          },
        );
      } else {
        Fonctions().openPageToGo(
          context: context,
          pageToGo: DashboardAgentsLoginPage(),
          replacePage: true,
        );
      }
    } else {
      Fonctions().openPageToGo(
        context: context,
        pageToGo: DashboardAgentsLoginPage(),
        replacePage: true,
      );
    }
  }

  @override
  void initState() {
    checkAgents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyBodyPage(
      backColor: Colors.white,
      colorRound: true,
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
