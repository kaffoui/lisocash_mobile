// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import '../constants/constants.dart';
import 'Pays.dart';

class Users {
  int? id;
  int? pays_id;
  String? nom;
  String? prenom;
  String? genre;
  String? adresse;
  String? quartier;
  String? ville;
  String? mail;
  String? code_whatsapp;
  String? code_telephone;
  String? whatsapp;
  String? telephone;
  String? solde;
  String? code_secret;
  String? ip_adresse;
  String? statut;
  String? password;
  String? type_user;
  String? lien_pp;
  String? lien_cni;
  String? lien_adresse;
  String? is_cni_validated;
  String? is_adresse_validated;
  String? fcm_token;
  String? date_enregistrement;

  Pays? pays;

  Users({
    this.id,
    this.pays_id,
    this.nom,
    this.prenom,
    this.genre,
    this.adresse,
    this.quartier,
    this.ville,
    this.mail,
    this.code_whatsapp,
    this.code_telephone,
    this.whatsapp,
    this.telephone,
    this.solde,
    this.code_secret,
    this.ip_adresse,
    this.statut,
    this.password,
    this.type_user,
    this.lien_pp,
    this.lien_cni,
    this.lien_adresse,
    this.is_cni_validated,
    this.is_adresse_validated,
    this.fcm_token,
    this.date_enregistrement,
    this.pays,
  });

  Users copyWith({
    int? id,
    int? pays_id,
    String? nom,
    String? prenom,
    String? genre,
    String? adresse,
    String? quartier,
    String? ville,
    String? mail,
    String? code_whatsapp,
    String? code_telephone,
    String? whatsapp,
    String? telephone,
    String? solde,
    String? code_secret,
    String? ip_adresse,
    String? statut,
    String? password,
    String? type_user,
    String? lien_pp,
    String? lien_cni,
    String? lien_adresse,
    String? is_cni_validated,
    String? is_adresse_validated,
    String? fcm_token,
    String? date_enregistrement,
    Pays? pays,
  }) {
    return Users(
      id: id ?? this.id,
      pays_id: pays_id ?? this.pays_id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      genre: genre ?? this.genre,
      adresse: adresse ?? this.adresse,
      quartier: quartier ?? this.quartier,
      ville: ville ?? this.ville,
      mail: mail ?? this.mail,
      code_whatsapp: code_whatsapp ?? this.code_whatsapp,
      code_telephone: code_telephone ?? this.code_telephone,
      whatsapp: whatsapp ?? this.whatsapp,
      telephone: telephone ?? this.telephone,
      solde: solde ?? this.solde,
      code_secret: code_secret ?? this.code_secret,
      ip_adresse: ip_adresse ?? this.ip_adresse,
      statut: statut ?? this.statut,
      password: password ?? this.password,
      type_user: type_user ?? this.type_user,
      lien_pp: lien_pp ?? this.lien_pp,
      lien_cni: lien_cni ?? this.lien_cni,
      lien_adresse: lien_adresse ?? this.lien_adresse,
      is_cni_validated: is_cni_validated ?? this.is_cni_validated,
      is_adresse_validated: is_adresse_validated ?? this.is_adresse_validated,
      fcm_token: fcm_token ?? this.fcm_token,
      date_enregistrement: date_enregistrement ?? this.date_enregistrement,
      pays: pays ?? this.pays,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pays_id': pays_id,
      'nom': nom,
      'prenom': prenom,
      'genre': genre,
      'adresse': adresse,
      'quartier': quartier,
      'ville': ville,
      'mail': mail,
      'code_whatsapp': code_whatsapp,
      'code_telephone': code_telephone,
      'whatsapp': whatsapp,
      'telephone': telephone,
      'solde': solde,
      'code_secret': code_secret,
      'ip_adresse': ip_adresse,
      'statut': statut,
      'password': password,
      'type_user': type_user,
      'lien_pp': lien_pp,
      'lien_cni': lien_cni,
      'lien_adresse': lien_adresse,
      'is_cni_validated': is_cni_validated,
      'is_adresse_validated': is_adresse_validated,
      'fcm_token': fcm_token,
      'date_enregistrement': date_enregistrement,
      'pays': pays?.toMap(),
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] != null ? map['id'] as int : null,
      pays_id: map['pays_id'] != null ? map['pays_id'] as int : null,
      nom: map['nom'] != null ? map['nom'] as String : null,
      prenom: map['prenom'] != null ? map['prenom'] as String : null,
      genre: map['genre'] != null ? map['genre'] as String : null,
      adresse: map['adresse'] != null ? map['adresse'] as String : null,
      quartier: map['quartier'] != null ? map['quartier'] as String : null,
      ville: map['ville'] != null ? map['ville'] as String : null,
      mail: map['mail'] != null ? map['mail'] as String : null,
      code_whatsapp: map['code_whatsapp'] != null ? map['code_whatsapp'] as String : null,
      code_telephone: map['code_telephone'] != null ? map['code_telephone'] as String : null,
      whatsapp: map['whatsapp'] != null ? map['whatsapp'] as String : null,
      telephone: map['telephone'] != null ? map['telephone'] as String : null,
      solde: map['solde'] != null ? map['solde'] as String : null,
      code_secret: map['code_secret'] != null ? map['code_secret'] as String : null,
      ip_adresse: map['ip_adresse'] != null ? map['ip_adresse'] as String : null,
      statut: map['statut'] != null ? map['statut'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      type_user: map['type_user'] != null ? map['type_user'] as String : null,
      lien_pp: map['lien_pp'] != null ? map['lien_pp'] as String : null,
      lien_cni: map['lien_cni'] != null ? map['lien_cni'] as String : null,
      lien_adresse: map['lien_adresse'] != null ? map['lien_adresse'] as String : null,
      is_cni_validated: map['is_cni_validated'] != null ? map['is_cni_validated'] as String : null,
      is_adresse_validated: map['is_adresse_validated'] != null ? map['is_adresse_validated'] as String : null,
      fcm_token: map['fcm_token'] != null ? map['fcm_token'] as String : null,
      date_enregistrement: map['date_enregistrement'] != null ? map['date_enregistrement'] as String : null,
      pays: map['pays'] != null ? Pays.fromMap(map['pays'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Users(id: $id, pays_id: $pays_id, nom: $nom, prenom: $prenom, genre: $genre, adresse: $adresse, quartier: $quartier, ville: $ville, mail: $mail, code_whatsapp: $code_whatsapp, code_telephone: $code_telephone, whatsapp: $whatsapp, telephone: $telephone, solde: $solde, code_secret: $code_secret, ip_adresse: $ip_adresse, statut: $statut, password: $password, type_user: $type_user, lien_pp: $lien_pp, lien_cni: $lien_cni, lien_adresse: $lien_adresse, is_cni_validated: $is_cni_validated, is_adresse_validated: $is_adresse_validated, fcm_token: $fcm_token, date_enregistrement: $date_enregistrement, pays: $pays)';
  }

  @override
  bool operator ==(covariant Users other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.pays_id == pays_id &&
        other.nom == nom &&
        other.prenom == prenom &&
        other.genre == genre &&
        other.adresse == adresse &&
        other.quartier == quartier &&
        other.ville == ville &&
        other.mail == mail &&
        other.code_whatsapp == code_whatsapp &&
        other.code_telephone == code_telephone &&
        other.whatsapp == whatsapp &&
        other.telephone == telephone &&
        other.solde == solde &&
        other.code_secret == code_secret &&
        other.ip_adresse == ip_adresse &&
        other.statut == statut &&
        other.password == password &&
        other.type_user == type_user &&
        other.lien_pp == lien_pp &&
        other.lien_cni == lien_cni &&
        other.lien_adresse == lien_adresse &&
        other.is_cni_validated == is_cni_validated &&
        other.is_adresse_validated == is_adresse_validated &&
        other.fcm_token == fcm_token &&
        other.date_enregistrement == date_enregistrement &&
        other.pays == pays;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pays_id.hashCode ^
        nom.hashCode ^
        prenom.hashCode ^
        genre.hashCode ^
        adresse.hashCode ^
        quartier.hashCode ^
        ville.hashCode ^
        mail.hashCode ^
        code_whatsapp.hashCode ^
        code_telephone.hashCode ^
        whatsapp.hashCode ^
        telephone.hashCode ^
        solde.hashCode ^
        code_secret.hashCode ^
        ip_adresse.hashCode ^
        statut.hashCode ^
        password.hashCode ^
        type_user.hashCode ^
        lien_pp.hashCode ^
        lien_cni.hashCode ^
        lien_adresse.hashCode ^
        is_cni_validated.hashCode ^
        is_adresse_validated.hashCode ^
        fcm_token.hashCode ^
        date_enregistrement.hashCode ^
        pays.hashCode;
  }

  bool get isAdmin => type_user!.toLowerCase() == TYPE_USER.ADMIN.name.toLowerCase();
  bool get isUser => type_user!.toLowerCase() == TYPE_USER.USER.name.toLowerCase();
  bool get isSuperAdmin => type_user!.toLowerCase() == TYPE_USER.SUPER_ADMIN.name.toLowerCase();
  bool get isAgent => type_user!.toLowerCase() == TYPE_USER.AGENT.name.toLowerCase();
  bool get isDistributeur => type_user!.toLowerCase() == TYPE_USER.DISTRIBUTEUR.name.toLowerCase();

  bool get isVerifier => statut!.toLowerCase() == STATUT_USER.IS_VERIFIER.name.toLowerCase();
  bool get isNonVerifier => statut!.toLowerCase() == STATUT_USER.IS_NON_VERIFIER.name.toLowerCase();
  bool get isBlacklisted => statut!.toLowerCase() == STATUT_USER.IS_BLACKLISTED.name.toLowerCase();
  bool get isRedlisted => statut!.toLowerCase() == STATUT_USER.IS_REDLISTED.name.toLowerCase();

  bool get isCniValidated => is_cni_validated == "1";
  bool get isAdresseValidated => is_adresse_validated == "1";

  bool get isHomme => genre!.toLowerCase() == GENRE.HOMME.name.toLowerCase();
  bool get isFemme => genre!.toLowerCase() == GENRE.FEMME.name.toLowerCase();
  bool get isAutre => genre!.toLowerCase() == GENRE.AUTRE.name.toLowerCase();
}
