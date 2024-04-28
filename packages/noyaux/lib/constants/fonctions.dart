import 'dart:convert';
import 'dart:math';

import 'package:country_ip/country_ip.dart' as ci;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:noyaux/widgets/N_ErrorWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Pays.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import 'constants.dart' as constant;
import 'styles.dart';

enum FORMATTYPE { DOUBLE, INTEGER }

enum PICKIMAGE { SINGLEIMAGE, MULTIPLEIMAGE, VIDEO }

enum SOURCEPICKIMAGE { GALLERY, CAMERA }

enum TYPEWIDGETERROR { DIALOG, BOTTOMSHEET }

class Fonctions {
  Random _random = Random();

  bool isSmallScreen(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.width;
    return smallestDimension < 768;
  }

  bool isMediumScreen(BuildContext context) {
    var mediumestDimension = MediaQuery.of(context).size.width;
    return mediumestDimension < 992 && mediumestDimension > 767;
  }

  bool isLargeScreen(BuildContext context) {
    var largestDimension = MediaQuery.of(context).size.width;
    return largestDimension > 991;
  }

  bool isNumeric(String s, {FORMATTYPE? formattype}) {
    switch (formattype) {
      case FORMATTYPE.DOUBLE:
        return double.tryParse(s) != null;
      case FORMATTYPE.INTEGER:
        return int.tryParse(s) != null;
      default:
        return false;
    }
  }

  String removeAccents(String? str) {
    str = str ?? "";
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str!.replaceAll(withDia[i], withoutDia[i]);
    }

    return str!.toLowerCase();
  }

  String displayDate(String date) {
    int seconds = DateTime.now().difference(DateTime.parse(date)).inSeconds;

    if (seconds < 60) {
      return "Il y a $seconds s";
    } else if (seconds >= 60 && seconds < 3600) {
      return "Il y a ${DateTime.now().difference(DateTime.parse(date)).inMinutes} min.";
    } else if (seconds >= 3600 && seconds < 3600 * 24) {
      return "Il y a ${DateTime.now().difference(DateTime.parse(date)).inHours} h";
    } else if (seconds >= 3600 * 24 && seconds < 3600 * 24 * 7) {
      return "Il y a ${DateTime.now().difference(DateTime.parse(date)).inDays} j";
    } else if (seconds >= 3600 * 24 * 7 && seconds < 3600 * 24 * 7 * 4) {
      int week = (DateTime.now().difference(DateTime.parse(date)).inDays.toInt() / 7).round();
      return "Il y a $week sem.";
    } else if (seconds >= 3600 * 24 * 7 * 4 && seconds < 3600 * 24 * 7 * 4 * 12) {
      int months = (DateTime.now().difference(DateTime.parse(date)).inDays.toInt() / 30).round();
      return "Il y a $months mois";
    } else {
      int years = (DateTime.now().difference(DateTime.parse(date)).inDays.toInt() / 360).round();
      return "Il y a $years a";
    }
  }

  Future<void> shareApp({String sujet = "", String text = ""}) async {
    Share.share(text, subject: sujet);
  }

  String formatDateTime(String date) {
    if (!date.contains(":")) {
      date = "$date 00:00:00";
    }
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var date1 = inputFormat.parse(date);

    var outputFormat = DateFormat("dd/MM/yyyy à HH : mm");
    String dateSortie =
        outputFormat.format(date1).replaceAll(" : ", "h").replaceAll("à 00h00", "").trim();
    dateSortie = dateSortie.contains("/0001") ? "" : dateSortie;
    return dateSortie;
  }

  Future<bool> joinOnWhatsapp({required String number, String? message = ""}) async {
    String urlWhatsapp = kIsWeb
        ? "https://wa.me/" + number.replaceAll('+', "") + "?text=$message"
        : "whatsapp://send?phone=$number" + "&text=$message";
    if (await canLaunchUrl(Uri.parse(urlWhatsapp))) {
      await launchUrl(Uri.parse(urlWhatsapp));
      return true;
    } else {
      return false;
    }
  }

  String generateV4() {
    final int special = int.parse("${100 + _random.nextInt(12)}");

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) => value.toRadixString(16).padLeft(count, '0');

  DateTime stringToDateTime(String text) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").parse(text);
  }

  Future<Pays> getPaysFromIp() async {
    IpAddress ipAddress = IpAddress(type: RequestType.json);

    final ip = await ipAddress.getIpAddress();

    final countryIpResponse = await ci.CountryIp.findFromIP(ip["ip"]);

    Pays _selectedPays = await Preferences()
        .getPaysListFromLocal(code: countryIpResponse!.countryCode)
        .then((value) => value.first);
    return _selectedPays;
  }

  Future<bool> callPhone(String phone) async {
    String url = "tel:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      return true;
    } else {
      return false;
    }
  }

  void showMediaLargeDialog({
    required BuildContext context,
    required List<String> imageLinkList,
    void Function()? onTap,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) {
        return Container(
          child: Scaffold(
            backgroundColor: Colors.black54,
            body: Stack(
              children: [
                PhotoView(
                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                  imageProvider: NetworkImage(
                    imageLinkList[0],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSize defaultAppBar({
    required BuildContext context,
    String titre = "",
    dynamic object,
    GlobalKey<ScaffoldState>? scaffoldKey,
    BuildContext? homeContext,
    double tailleAppBar = 48,
    double taillBottom = 0.10,
    Color? iconColor,
    Color? titreColor,
    Color? backgroundColor,
    bool centerTitle = false,
    bool isNotRoot = false,
    bool isAdmin = false,
    bool isEspaceEntrerise = false,
    bool showAccount = false,
    bool showTitle = true,
    bool showLeading = false,
    double elevation = 2,
    Widget? leadingWidget,
    Widget? titleWidget,
    Widget? actionWidget,
    Widget? bottomWidget,
    Widget? customView,
    int? currentIndexPage,
  }) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(tailleAppBar),
      child: customView ??
          AppBar(
            iconTheme: IconThemeData(color: iconColor ?? Theme.of(context).primaryColor),
            leading: leadingWidget,
            title: titleWidget ??
                NDisplayTextWidget(
                  text: titre,
                  maxLines: 1,
                  textColor: titreColor ?? theme.primaryColor,
                  overflow: TextOverflow.ellipsis,
                ),
            centerTitle: centerTitle,
            elevation: elevation,
            backgroundColor: Fonctions().isSmallScreen(context)
                ? backgroundColor ?? Colors.white
                : backgroundColor ?? Colors.white,
            //theme.colorScheme.secondary,
            actions: <Widget>[
              if (actionWidget != null) actionWidget,
              //if (isAdmin)
              if (showAccount)
                PopupMenuButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: <Widget>[
                        /*Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),*/
                      ],
                    ),
                  ),
                  itemBuilder: (context) => object != null
                      ? [
                          PopupMenuItem(
                            height: 35,
                            value: 1,
                            child: NDisplayTextWidget(
                              text: "Mon Profile",
                            ),
                          ),
                        ]
                      : [
                          PopupMenuItem(
                            height: 35,
                            value: 1,
                            child: NDisplayTextWidget(
                              text: "Se connecter",
                            ),
                          ),
                        ],
                  onSelected: (value) async {
                    if (value == 1) {
                      if (object != null) {
                        scaffoldKey!.currentState!.openEndDrawer();
                      } else {}
                    } else {}
                  },
                ),
            ],
            bottom: bottomWidget != null
                ? PreferredSize(
                    preferredSize:
                        Size.fromHeight(MediaQuery.of(context).size.height * taillBottom),
                    child: bottomWidget,
                  )
                : null,
          ),
    );
  }

  Future<bool> openUrl(String url, [String domain = ""]) async {
    if (url.contains("@") && !url.startsWith('mailto')) {
      url = 'mailto:$url';
    } else if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      if (url.contains("t.me")) {
        canLaunchUrl(Uri(scheme: 'tg', path: 'resolve?domain=$domain')).then((bool result) {
          launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
        });
      } else {
        await launchUrl(Uri.parse(url));
      }
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> openPageToGo({
    required BuildContext context,
    required Widget pageToGo,
    bool replacePage = false,
  }) async {
    if (replacePage) {
      return await Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (contextPage, _, __) => pageToGo,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      return await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (contextPage, _, __) => pageToGo,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> pickWebImage({
    PICKIMAGE pickimage = PICKIMAGE.SINGLEIMAGE,
    SOURCEPICKIMAGE sourcepickimage = SOURCEPICKIMAGE.GALLERY,
    int imageQuality = constant.Constants.kImageQuality,
  }) async {
    if (pickimage == PICKIMAGE.SINGLEIMAGE) {
      final imagePick = await ImagePicker().pickImage(
        source:
            sourcepickimage == SOURCEPICKIMAGE.GALLERY ? ImageSource.gallery : ImageSource.camera,
        imageQuality: imageQuality,
      );
      final uint = await imagePick!.readAsBytes();
      final base64 = base64Encode(uint);
      return {
        "name": "${imagePick.name}",
        "path": "${imagePick.path}",
        "base64": "$base64",
        "bytes": "$uint"
      };
    } else {
      throw UnimplementedError(
        "Not implemented",
      );
    }
  }

  Future<dynamic> showWidgetAsModalSheet({
    required BuildContext context,
    String title = "",
    required Widget widget,
    double paddingContent = 12.0,
    double maxHeight = 400,
    Color? titleColor,
    Color? backgroundColor,
    Color? barrierColor,
    bool useSafeArea = false,
    bool useConstraint = false,
    bool showHeader = true,
    bool isDismissible = false,
    void Function()? onCloseDialog,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      constraints: useConstraint ? BoxConstraints(maxHeight: maxHeight) : null,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      barrierColor: barrierColor,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 8.0),
              if (showHeader)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      NDisplayTextWidget(
                        text: title,
                        theme: BASE_TEXT_THEME.TITLE,
                        textColor: titleColor,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (onCloseDialog != null) onCloseDialog();
                        },
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.close),
                      ),
                      SizedBox(width: 12.0),
                    ],
                  ),
                ),
              Container(
                padding: EdgeInsets.all(paddingContent),
                child: widget,
              ),
            ],
          ),
        );
      },
    );
  }

  Future selectedDate({
    required BuildContext contextDate,
    required TextEditingController dateController,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDate,
    String formatDate = 'yyyy-MM-dd',
    void Function(TextEditingController controller)? onChangedDateController,
  }) async {
    final DateTime? datepick = await showDatePicker(
      context: contextDate,
      locale: const Locale("fr", "FR"),
      initialDatePickerMode: DatePickerMode.day,
      initialDate: initialDate != null ? initialDate : firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );
    if (datepick != null) {
      dateController.text = DateFormat(formatDate).format(datepick);
      if (onChangedDateController != null) {
        onChangedDateController(dateController);
      }
    }
  }

  Future selectedTime({
    required BuildContext context,
    required TextEditingController timeController,
    TimeOfDay? initialTime,
    String textCancelButton = "Annuler",
    Color? primaryColor,
    void Function(TimeOfDay timePiked)? onSelectedTime,
  }) async {
    final timepick = await showRoundedTimePicker(
      context: context,
      initialTime: initialTime != null ? initialTime : TimeOfDay.now(),
      locale: const Locale("fr", "FR"),
      barrierDismissible: true,
      negativeBtn: textCancelButton,
      theme: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                brightness: Brightness.dark,
                background: Colors.grey.shade400,
                // primary: ConstantColor.primaryColor,
                //secondary: Colors.white,
              ),
          cardColor: Colors.red,
          primaryColorLight: Colors.green),
    );
    if (timepick != null) {
      timeController.text =
          "${timepick.hour.toString().padLeft(2, '0')} : ${timepick.minute.toString().padLeft(2, '0')}";
      if (onSelectedTime != null) {
        onSelectedTime(timepick);
      }
    }
  }

  Future<dynamic> showWidgetAsDialog({
    required BuildContext context,
    required Widget widget,
    String title = "",
    Widget? titleWidget,
    double paddingContent = 12.0,
    Color? titleColor,
    Color? backColor,
    Function? onCloseDialog,
    EdgeInsets? insetPadding,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          elevation: 0.0,
          backgroundColor: backColor,
          title: titleWidget ??
              (title.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title,
                          style: Style.defaultTextStyle(textSize: 11.0),
                        ),
                        NButtonWidget(
                          iconData: Icons.close,
                          iconColor: Colors.white,
                          action: () {
                            if (onCloseDialog != null) onCloseDialog();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  : null),
          insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          scrollable: true,
          content: Container(
            padding: EdgeInsets.all(paddingContent),
            child: widget,
          ),
        );
      },
    );
  }

  Future showErrorAsWidget({
    required BuildContext context,
    required String message,
    String linkImageError = "",
    String assetPath = "",
    String titre = "",
    String buttonText = "",
    TextStyle? titreStyle,
    TYPEWIDGETERROR typewidgeterror = TYPEWIDGETERROR.BOTTOMSHEET,
    void Function()? action,
  }) async {
    if (typewidgeterror == TYPEWIDGETERROR.DIALOG) {
      await showDialog(
        context: context,
        useRootNavigator: true,
        useSafeArea: true,
        builder: (contextError) {
          return AlertDialog(
            title: titre.isNotEmpty
                ? NDisplayTextWidget(
                    text: titre,
                    theme: BASE_TEXT_THEME.TITLE,
                  )
                : null,
            content: Container(
              padding: EdgeInsets.all(12.0),
              child: NErrorWidget(
                message: "$message",
                buttonText: buttonText,
                onPressed: action,
                imageLink: assetPath,
              ),
            ),
          );
        },
      );
    } else {
      await showModalBottomSheet(
        context: context,
        builder: (contextError) {
          return Container(
            height: 500,
            padding: EdgeInsets.all(12.0),
            child: NErrorWidget(
              backgroundColor: Colors.transparent,
              message: "$message",
              buttonText: buttonText,
              onPressed: action,
              imageLink: assetPath,
            ),
          );
        },
      );
    }
  }
}
