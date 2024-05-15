// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:noyaux/models/Notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Agents.dart';
import '../models/Configuration.dart';
import '../models/Frais.dart';
import '../models/Operation.dart';
import '../models/Pays.dart';
import '../models/Taux.dart';
import '../models/Users.dart';
import 'api/Api.dart';

class Preferences {
  static const PREFS_KEY_Configuration = '2MCJM1A5RW';
  static const PREFS_KEY_Operation = 'HSF15ZV8GL';
  static const PREFS_KEY_Frais = 'XHUKAJPQSW';
  static const PREFS_KEY_Agents = 'ILSHCNABHA';
  static const PREFS_KEY_Pays = 'PFCXDN9DC9';
  static const PREFS_KEY_Taux = 'iJmn5L46K9';
  static const PREFS_KEY_Notifications = 'TKOKYYMXLD';
  static const PREFS_KEY_Users = '54LKnmJi96';
  static const PREFS_KEY_UsersID = 'n4m9J5KLi6';

  bool skipLocal;

  Preferences({this.skipLocal = true});

  static Future<void> refreshData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
  }

  static Future<void> removeData({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  static Future<void> clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static Future<void> saveData({required String key, required dynamic data}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (data is String) {
      await preferences.setString(key, data);
    } else if (data is bool) {
      await preferences.setBool(key, data);
    } else {
      await preferences.setString(key, jsonEncode(data));
    }
  }

  Future<String> getIdUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('$PREFS_KEY_UsersID') ?? "";
    return data;
  }

  Future<List<Configuration>> getConfigurationListFromLocal({String? id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('$PREFS_KEY_Configuration$id') ?? '';
    if (json.isEmpty || skipLocal) {
      await Api().getConfiguration(id: id);
    } else {
      Api().getConfiguration(id: id);
    }
    prefs = await SharedPreferences.getInstance();
    json = prefs.getString('$PREFS_KEY_Configuration$id') ?? '';

    if (json.isEmpty) {
      return [];
    } else {
      List<dynamic> body = jsonDecode(json);
      List<Configuration> list = body.map((dynamic item) => Configuration.fromMap(item)).toList();
      return list;
    }
  }

  Future<List<Agents>> getAgentsListFromLocal({String? id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('$PREFS_KEY_Agents$id') ?? '';
    if (json.isEmpty || skipLocal) {
      await Api().getAgents(id: id);
    } else {
      Api().getAgents(id: id);
    }
    prefs = await SharedPreferences.getInstance();
    json = prefs.getString('$PREFS_KEY_Agents$id') ?? '';

    if (json.isEmpty) {
      return [];
    } else {
      List<dynamic> body = jsonDecode(json);
      List<Agents> list = body.map((dynamic item) => Agents.fromMap(item)).toList();
      return list;
    }
  }

  Future<List<Frais>> getFraisListFromLocal({String? id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('$PREFS_KEY_Frais$id') ?? '';
    if (json.isEmpty || skipLocal) {
      await Api().getFrais(id: id);
    } else {
      Api().getFrais(id: id);
    }
    prefs = await SharedPreferences.getInstance();
    json = prefs.getString('$PREFS_KEY_Frais$id') ?? '';

    if (json.isEmpty) {
      return [];
    } else {
      List<dynamic> body = jsonDecode(json);
      List<Frais> list = body.map((dynamic item) => Frais.fromMap(item)).toList();
      return list;
    }
  }

  Future<List<Operation>> getOperationListFromLocal(
      {String? id, String? user_id_from, String? user_id_to}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('$PREFS_KEY_Operation$id$user_id_from$user_id_to') ?? '';
    if (json.isEmpty || skipLocal) {
      await Api().getOperation(id: id, user_id_from: user_id_from, user_id_to: user_id_to);
    } else {
      Api().getOperation(id: id, user_id_from: user_id_from, user_id_to: user_id_to);
    }
    prefs = await SharedPreferences.getInstance();
    json = prefs.getString('$PREFS_KEY_Operation$id$user_id_from$user_id_to') ?? '';

    if (json.isEmpty) {
      return [];
    } else {
      List<dynamic> body = jsonDecode(json);
      List<Operation> list = body.map((dynamic item) => Operation.fromMap(item)).toList();
      return list;
    }
  }

  Future<List<Pays>> getPaysListFromLocal({String? id, String? code}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('$PREFS_KEY_Pays$id$code') ?? '';
    if (json.isEmpty || skipLocal) {
      await Api().getPays(id: id, code: code);
    } else {
      Api().getPays(id: id, code: code);
    }
    prefs = await SharedPreferences.getInstance();
    json = prefs.getString('$PREFS_KEY_Pays$id$code') ?? '';

    if (json.isEmpty) {
      return [];
    } else {
      List<dynamic> body = jsonDecode(json);
      List<Pays> list = body.map((dynamic item) => Pays.fromMap(item)).toList();
      return list;
    }
  }

  Future<List<Notifications>> getNotificationsListFromLocal({String? id, String? user_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('$PREFS_KEY_Notifications$id$user_id') ?? '';
    if (json.isEmpty || skipLocal) {
      await Api().getNotifications(id: id, user_id: user_id);
    } else {
      Api().getNotifications(id: id, user_id: user_id);
    }
    prefs = await SharedPreferences.getInstance();
    json = prefs.getString('$PREFS_KEY_Notifications$id$user_id') ?? '';

    if (json.isEmpty) {
      return [];
    } else {
      List<dynamic> body = jsonDecode(json);
      List<Notifications> list = body.map((dynamic item) => Notifications.fromMap(item)).toList();
      return list;
    }
  }

  Future<List<Taux>> getTauxListFromLocal({String? id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('$PREFS_KEY_Taux$id') ?? '';
    if (json.isEmpty || skipLocal) {
      await Api().getTaux(id: id);
    } else {
      Api().getTaux(id: id);
    }
    prefs = await SharedPreferences.getInstance();
    json = prefs.getString('$PREFS_KEY_Taux$id') ?? '';

    if (json.isEmpty) {
      return [];
    } else {
      List<dynamic> body = jsonDecode(json);
      List<Taux> list = body.map((dynamic item) => Taux.fromMap(item)).toList();
      return list;
    }
  }

  Future<List<Users>> getUsersListFromLocal({String? id, String? mail, String? password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('$PREFS_KEY_Users$id$mail$password') ?? '';
    if (json.isEmpty || skipLocal) {
      await Api().getUsers(id: id, mail: mail, password: password);
    } else {
      Api().getUsers(id: id, mail: mail, password: password);
    }
    prefs = await SharedPreferences.getInstance();
    json = prefs.getString('$PREFS_KEY_Users$id$mail$password') ?? '';

    if (json.isEmpty) {
      return [];
    } else {
      List<dynamic> body = jsonDecode(json);
      List<Users> list = body.map((dynamic item) => Users.fromMap(item)).toList();
      return list;
    }
  }
}
