// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../models/Currency.dart';
import '../Preferences.dart';
import '../url.dart';

class Api {
  @protected
  final String apiKey = 'cur_live_cRbtP4u8ICLFyT66Vvy0eAZMJeDIrDJxM8dab6Ym';

  static Future<Map<String, dynamic>> saveObjetApi({
    required var arguments,
    required String url,
    Map<String, dynamic>? additionalArgument,
  }) async {
    Uri uri = Uri.https(Url.urlServer, url);
    var dataToSend;
    if (arguments is Map<String, dynamic>) {
      dataToSend = arguments;
    } else {
      dataToSend = arguments.toMap();
    }

    if (additionalArgument != null) {
      dataToSend.addEntries(additionalArgument.entries);
    }
    try {
      dataToSend.updateAll((key, value) => value);

      dataToSend.updateAll((key, value) => value == null ? "" : value.toString().trim());
      dataToSend.updateAll((key, value) => value is Map<String, dynamic> ? "" : value);
      print("dataToSend: $dataToSend");

      http.Response response = await http.post(uri, body: dataToSend);
      print("url: $uri\ncode: ${response.statusCode}\nresponse: ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        if (body["code"] == "100") {
          return {"saved": true, "inserted_id": body["inserted_id"], "message_error": null};
        } else if (body["code"] == "101") {
          return {"saved": false, "message_error": body["message"]};
        } else {
          return {"saved": false, "message_error": "Une erreur s'est produite"};
        }
      } else {
        return {"saved": false, "message_error": "Une erreur s'est produite"};
      }
    } on SocketException {
      return {"saved": false, "message_error": "Veuillez vous connectez à internet"};
    } catch (e) {
      return {"saved": false, "message_error": "$e"};
    }
  }

  Future getConfiguration({String? id}) async {
    Map<String, String> params = {
      "id": id != null ? "$id" : "",
    };
    Uri url = Uri.https(Url.urlServer, Url.ConfigurationUrl, params);

    try {
      http.Response response = await http.get(url);

      String json = jsonEncode(jsonDecode(response.body)['data']).toString();
      if (response.statusCode == 200 && jsonDecode(response.body)['code'] == "100") {
        await Preferences.saveData(key: '${Preferences.PREFS_KEY_Configuration}$id', data: json);
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future getFrais({String? id}) async {
    Map<String, String> params = {
      "id": id != null ? "$id" : "",
    };
    Uri url = Uri.https(Url.urlServer, Url.FraisUrl, params);

    try {
      http.Response response = await http.get(url);

      String json = jsonEncode(jsonDecode(response.body)['data']).toString();
      if (response.statusCode == 200 && jsonDecode(response.body)['code'] == "100") {
        await Preferences.saveData(key: '${Preferences.PREFS_KEY_Frais}$id', data: json);
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future getOperation({String? id, String? user_id_from, String? user_id_to}) async {
    Map<String, String> params = {
      "id": id != null ? "$id" : "",
      "user_id_from": user_id_from != null ? "$user_id_from" : "",
      "user_id_to": user_id_to != null ? "$user_id_to" : "",
    };
    Uri url = Uri.https(Url.urlServer, Url.OperationUrl, params);

    try {
      http.Response response = await http.get(url);

      String json = jsonEncode(jsonDecode(response.body)['data']).toString();
      if (response.statusCode == 200 && jsonDecode(response.body)['code'] == "100") {
        await Preferences.saveData(
            key: '${Preferences.PREFS_KEY_Operation}$id$user_id_from$user_id_to', data: json);
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future getPays({String? id, String? code}) async {
    Map<String, String> params = {
      "id": id != null ? "$id" : "",
      "code": code != null ? "$code" : "",
    };
    Uri url = Uri.https(Url.urlServer, Url.PaysUrl, params);

    try {
      http.Response response = await http.get(url);
      print("url: $url\nbody: ${response.body}");
      String json = jsonEncode(jsonDecode(response.body)['data']).toString();
      if (response.statusCode == 200 && jsonDecode(response.body)['code'] == "100") {
        await Preferences.saveData(key: '${Preferences.PREFS_KEY_Pays}$id$code', data: json);
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future getNotifications({String? id, String? user_id}) async {
    Map<String, String> params = {
      "id": id != null ? "$id" : "",
      "user_id": user_id != null ? "$user_id" : "",
    };
    Uri url = Uri.https(Url.urlServer, Url.NotificationsUrl, params);

    try {
      http.Response response = await http.get(url);
      String json = jsonEncode(jsonDecode(response.body)['data']).toString();

      if (response.statusCode == 200 && jsonDecode(response.body)['code'] == "100") {
        await Preferences.saveData(
            key: '${Preferences.PREFS_KEY_Notifications}$id$user_id', data: json);
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future getTaux({String? id}) async {
    Map<String, String> params = {
      "id": id != null ? "$id" : "",
    };
    Uri url = Uri.https(Url.urlServer, Url.TauxUrl, params);

    try {
      http.Response response = await http.get(url);

      String json = jsonEncode(jsonDecode(response.body)['data']).toString();
      if (response.statusCode == 200 && jsonDecode(response.body)['code'] == "100") {
        await Preferences.saveData(key: '${Preferences.PREFS_KEY_Taux}$id', data: json);
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future getUsers({String? id, String? mail, String? password}) async {
    Map<String, String> params = {
      "id": id != null ? "$id" : "",
      "mail": mail != null ? "$mail" : "",
      "password": password != null ? "$password" : "",
    };
    Uri url = Uri.https(Url.urlServer, Url.UsersUrl, params);

    try {
      http.Response response = await http.get(url);

      String json = jsonEncode(jsonDecode(response.body)['data']).toString();
      if (response.statusCode == 200 && jsonDecode(response.body)['code'] == "100") {
        await Preferences.saveData(
            key: '${Preferences.PREFS_KEY_Users}$id$mail$password', data: json);
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> sendOtp({required String phone}) async {
    Map<String, String> params = {
      "phone": "$phone",
    };
    Uri url = Uri.https(Url.urlServer, Url.SendOtpUrl);

    try {
      http.Response response = await http.post(url, body: params);

      if (response.statusCode == 200 && jsonDecode(response.body)['code'] == "100") {
        return {"send": true};
      } else {
        return {"send": false};
      }
    } on SocketException {
      return {"send": false, "error": "Vous n'êtes pas connecté à internet"};
    } catch (e) {
      return {"send": false, "error": "$e"};
    }
  }

  Future<List<Currency>> fetchCurrency(String? value) async {
    final response = await http.get(
        Uri.parse('https://api.currencyapi.com/v3/latest?apikey=${apiKey}&base_currency=${value}'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<Currency> currencies = [];
      for (var code in data["data"].keys) {
        Currency currency = Currency(
            code: data["data"][code]["code"], value: data["data"][code]["value"].toDouble());
        currencies.add(currency);
      }
      return currencies;
    } else {
      throw Exception('Failed');
    }
  }

  Future<Currency> fetchExchangeRate(String? baseValue, String? targetValue) async {
    final response = await http.get(Uri.parse(
        'https://api.currencyapi.com/v3/latest?apikey=${apiKey}&base_currency=${baseValue}&currencies=${targetValue}'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Currency currency = Currency(
        code: data["data"][targetValue]["code"],
        value: data["data"][targetValue]["value"].toDouble(),
      );
      return currency;
    } else {
      throw Exception('Failed');
    }
  }
}
