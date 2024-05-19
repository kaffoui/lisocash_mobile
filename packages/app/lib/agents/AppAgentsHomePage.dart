import 'package:flutter/material.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/models/Agents.dart';
import 'package:noyaux/models/Users.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/services/api/Api.dart';
import 'package:noyaux/services/url.dart';
import 'package:noyaux/widgets/N_ButtonWidget.dart';

class AppAgentsHomePage extends StatefulWidget {
  const AppAgentsHomePage({super.key});

  @override
  State<AppAgentsHomePage> createState() => _AppAgentsHomePageState();
}

class _AppAgentsHomePageState extends State<AppAgentsHomePage> {
  bool _isLoading = false;

  Users? _currentUser;
  Agents? _currentAgent;

  Future<void> _fetchInformations() async {
    setState(() {
      _isLoading = true;
    });

    final String userId = await Preferences().getIdUsers();
    final List<Users> usersList = await Preferences().getUsersListFromLocal(id: userId);
    if (usersList.isNotEmpty) {
      setState(() {
        _currentUser = usersList.first;
      });
    }

    final List<Agents> agentsList = await Preferences().getAgentsListFromLocal(id: userId);
    if (agentsList.isNotEmpty) {
      setState(() {
        _currentAgent = agentsList.first;
      });
    }

    print("current: $_currentAgent");

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchInformations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Container()
          : _currentAgent != null
              ? _buildAgentMenu()
              : _buildBecomeAgentButton(),
    );
  }

  Widget _buildAgentMenu() {
    return ListView(
      children: const [
        ListTile(
          title: Text('Dépôt'),
        ),
        ListTile(
          title: Text('Retrait'),
        ),
        ListTile(
          title: Text('Mes transactions'),
        ),
        ListTile(
          title: Text('Statistiques'),
        ),
      ],
    );
  }

  Widget _buildBecomeAgentButton() {
    return Center(
      child: NButtonWidget(
        text: "Devenir un agent",
        action: () {
          _becomeAgent();
        },
      ),
    );
  }

  Future<void> _becomeAgent() async {
    String uniqueCode = Fonctions().generateV4();
    final agent = Agents(
      id_users: _currentUser?.id,
      identifiant_unique: uniqueCode,
      solde: 0,
    );
    final result = await Api.saveObjetApi(arguments: agent, url: Url.AgentsUrl, additionalArgument: {'action': 'SAVE'});
    if (result["saved"]) {
      _fetchInformations();
    }
  }
}
