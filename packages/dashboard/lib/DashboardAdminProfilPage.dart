import 'package:flutter/material.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/modelsDetails/UsersDetailsPage.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/widgets/N_LoadingWidget.dart';

class DashboardAdminProfilPage extends StatefulWidget {
  const DashboardAdminProfilPage({super.key});

  @override
  State<DashboardAdminProfilPage> createState() => _DashboardAdminProfilPageState();
}

class _DashboardAdminProfilPageState extends State<DashboardAdminProfilPage> {
  Users? usersConnected;

  bool changeData = false;

  void getUsers() async {
    setState(() {
      changeData = true;
    });
    final id = await Preferences().getIdUsers();
    final data = await Preferences().getUsersListFromLocal(id: id);
    if (data.isNotEmpty) {
      setState(() {
        usersConnected = data.first;
      });
    }
    setState(() {
      changeData = false;
    });
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: usersConnected != null
          ? Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    Expanded(
                      child: UsersDetailsPage(
                        key: ValueKey<bool>(changeData),
                        users: usersConnected!,
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            )
          : Center(
              child: NLoadingWidget(),
            ),
    );
  }
}
