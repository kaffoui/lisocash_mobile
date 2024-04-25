import 'package:flutter/material.dart';

class Constants {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static const Color kPrimaryColor = Color(0xFF267ea2);
  static const Color kSecondColor = Color(0xFFffa405);
  static const Color kAccentColor = Color(0xFF153b62);
  static const Color kTextDefaultColor = Color(0xFF2C3E50);
  static const Color kErrorColor = Color(0xFFC0392B);
  static const Color kSuccessColor = Color(0xFF27AE60);

  static const String kClientID = "";
  static const String kApiKey = "";
  static const String kTitleApplication = "LISOCASH";
  static const String STRIPE_SECRET = "sk_test_51K9PWZAVayjfMa6fwwlf1ZjEIQV3ohA2fuWlvueSAIWGHOYJYHmqjZAEpcvMZZDbxQ2z9IKaRwj930nyc7UkXKdC00F89NLFve";
  static const String STRIPE_PUBLIC = "pk_test_51K9PWZAVayjfMa6fdh598Ltrn6qkEZGet7SH0CFhuc9cbPUKo7zMMCvhoCSHB6fCX2ITlpmyBKkZZfmX9mAz2OUc0047dx3thR";

  static const String STRIPE_DEV_SECRET =
      "sk_test_51KABdsFApRa46aJnBdNrokw82k2WUItKDRweOpQ7XZTyrpigk5C893MVtnpUKkvXIwzXxlH7P2h3fLgV00dE3JlR00RIMpxYxk";
  static const String STRIPE_DEV_PUBLISH =
      "pk_test_51KABdsFApRa46aJn2DYoL2Nk8MiKBkfim5GRDKXxO2avV1ycNdgOee7BCxG5LI5oG6Ta301N1daVcRYySrBxYwRB00qSjCSJ7u";

  static const int kImageQuality = 15;

  static const double taille = 16.0;
}

enum TYPE_USER { USER, ADMIN, SUPER_ADMIN, AGENT, DISTRIBUTEUR }

enum STATUT_USER { IS_VERIFIER, IS_BLACKLISTED, IS_REDLISTED, IS_NON_VERIFIER }

enum ETAT_OPERATION { EN_COURS, VALIDER, TERMINER, ANNULER }

enum TYPE_OPERATION { TRANSFERT, RECHARGEMENT, DEPOT, RETRAIT }

enum GENRE { HOMME, FEMME, AUTRE }

List<GENRE> genreListe = GENRE.values;

List<String> motifsList = [
  "Soutien familial",
  "Payer des factures",
  "Aide d'urgence",
  "Transferts d'entreprise",
  "Remboursements",
  "Soutien financier international",
  "Commerce électronique",
  "Payer pour des services",
  "Donations caritatives",
  "Cadeaux",
];
