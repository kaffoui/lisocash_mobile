// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:noyaux/constants/constants.dart';

import 'Frais.dart';
import 'Taux.dart';
import 'Users.dart';

class Operation {
  int? id;
  String? type_operation;
  int? frais_id;
  int? taux_id;
  int? user_id_from;
  int? user_id_to;
  String? montant;
  String? motif;
  String? etat_operation;
  String? date_envoie;
  String? date_reception;
  String? date_enregistrement;

  Frais? frais;
  Taux? taux;
  Users? user_from;
  Users? user_to;

  Operation({
    this.id,
    this.type_operation,
    this.frais_id,
    this.taux_id,
    this.user_id_from,
    this.user_id_to,
    this.montant,
    this.motif,
    this.etat_operation,
    this.date_envoie,
    this.date_reception,
    this.date_enregistrement,
    this.frais,
    this.taux,
    this.user_from,
    this.user_to,
  });

  Operation copyWith({
    int? id,
    String? type_operation,
    int? frais_id,
    int? taux_id,
    int? user_id_from,
    int? user_id_to,
    String? montant,
    String? motif,
    String? etat_operation,
    String? date_envoie,
    String? date_reception,
    String? date_enregistrement,
    Frais? frais,
    Taux? taux,
    Users? user_from,
    Users? user_to,
  }) {
    return Operation(
      id: id ?? this.id,
      type_operation: type_operation ?? this.type_operation,
      frais_id: frais_id ?? this.frais_id,
      taux_id: taux_id ?? this.taux_id,
      user_id_from: user_id_from ?? this.user_id_from,
      user_id_to: user_id_to ?? this.user_id_to,
      montant: montant ?? this.montant,
      motif: motif ?? this.motif,
      etat_operation: etat_operation ?? this.etat_operation,
      date_envoie: date_envoie ?? this.date_envoie,
      date_reception: date_reception ?? this.date_reception,
      date_enregistrement: date_enregistrement ?? this.date_enregistrement,
      frais: frais ?? this.frais,
      taux: taux ?? this.taux,
      user_from: user_from ?? this.user_from,
      user_to: user_to ?? this.user_to,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type_operation': type_operation,
      'frais_id': frais_id,
      'taux_id': taux_id,
      'user_id_from': user_id_from,
      'user_id_to': user_id_to,
      'montant': montant,
      'motif': motif,
      'etat_operation': etat_operation,
      'date_envoie': date_envoie,
      'date_reception': date_reception,
      'date_enregistrement': date_enregistrement,
      'frais': frais?.toMap(),
      'taux': taux?.toMap(),
      'user_from': user_from?.toMap(),
      'user_to': user_to?.toMap(),
    };
  }

  factory Operation.fromMap(Map<String, dynamic> map) {
    return Operation(
      id: map['id'] != null ? map['id'] as int : null,
      type_operation: map['type_operation'] != null ? map['type_operation'] as String : null,
      frais_id: map['frais_id'] != null ? map['frais_id'] as int : null,
      taux_id: map['taux_id'] != null ? map['taux_id'] as int : null,
      user_id_from: map['user_id_from'] != null ? map['user_id_from'] as int : null,
      user_id_to: map['user_id_to'] != null ? map['user_id_to'] as int : null,
      montant: map['montant'] != null ? map['montant'] as String : null,
      motif: map['motif'] != null ? map['motif'] as String : null,
      etat_operation: map['etat_operation'] != null ? map['etat_operation'] as String : null,
      date_envoie: map['date_envoie'] != null ? map['date_envoie'] as String : null,
      date_reception: map['date_reception'] != null ? map['date_reception'] as String : null,
      date_enregistrement: map['date_enregistrement'] != null ? map['date_enregistrement'] as String : null,
      frais: map['frais'] != null ? Frais.fromMap(map['frais'] as Map<String, dynamic>) : null,
      taux: map['taux'] != null ? Taux.fromMap(map['taux'] as Map<String, dynamic>) : null,
      user_from: map['user_from'] != null ? Users.fromMap(map['user_from'] as Map<String, dynamic>) : null,
      user_to: map['user_to'] != null ? Users.fromMap(map['user_to'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Operation.fromJson(String source) => Operation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Operation(id: $id, type_operation: $type_operation, frais_id: $frais_id, taux_id: $taux_id, user_id_from: $user_id_from, user_id_to: $user_id_to, montant: $montant, motif: $motif, etat_operation: $etat_operation, date_envoie: $date_envoie, date_reception: $date_reception, date_enregistrement: $date_enregistrement, frais: $frais, taux: $taux, user_from: $user_from, user_to: $user_to)';
  }

  @override
  bool operator ==(covariant Operation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type_operation == type_operation &&
        other.frais_id == frais_id &&
        other.taux_id == taux_id &&
        other.user_id_from == user_id_from &&
        other.user_id_to == user_id_to &&
        other.montant == montant &&
        other.motif == motif &&
        other.etat_operation == etat_operation &&
        other.date_envoie == date_envoie &&
        other.date_reception == date_reception &&
        other.date_enregistrement == date_enregistrement &&
        other.frais == frais &&
        other.taux == taux &&
        other.user_from == user_from &&
        other.user_to == user_to;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type_operation.hashCode ^
        frais_id.hashCode ^
        taux_id.hashCode ^
        user_id_from.hashCode ^
        user_id_to.hashCode ^
        montant.hashCode ^
        motif.hashCode ^
        etat_operation.hashCode ^
        date_envoie.hashCode ^
        date_reception.hashCode ^
        date_enregistrement.hashCode ^
        frais.hashCode ^
        taux.hashCode ^
        user_from.hashCode ^
        user_to.hashCode;
  }

  bool get isTransfert => this.type_operation!.toLowerCase() == TYPE_OPERATION.TRANSFERT.name.toLowerCase();
  bool get isRechargement => this.type_operation!.toLowerCase() == TYPE_OPERATION.RECHARGEMENT.name.toLowerCase();
  bool get isDepot => this.type_operation!.toLowerCase() == TYPE_OPERATION.DEPOT.name.toLowerCase();
  bool get isRetrait => this.type_operation!.toLowerCase() == TYPE_OPERATION.RETRAIT.name.toLowerCase();
}
