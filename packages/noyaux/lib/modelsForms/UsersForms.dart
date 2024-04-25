import 'package:flutter/material.dart';

import '../models/Users.dart';

class UsersFormWidget extends StatefulWidget {
  final Users objectUsers;
  const UsersFormWidget({super.key, required this.objectUsers});

  @override
  State<UsersFormWidget> createState() => _UsersFormWidgetState();
}

class _UsersFormWidgetState extends State<UsersFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
