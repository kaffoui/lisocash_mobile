// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'Pays.dart';

class Taux {
  int? id;
  String? date_taux;
  int? pays_id_from;
  int? pays_id_to;
  String? taux;
  String? date_enregistrement;

  Pays? pays_from;
  Pays? pays_to;

  Taux({
    this.id,
    this.date_taux,
    this.pays_id_from,
    this.pays_id_to,
    this.taux,
    this.date_enregistrement,
    this.pays_from,
    this.pays_to,
  });

  Taux copyWith({
    int? id,
    String? date_taux,
    int? pays_id_from,
    int? pays_id_to,
    String? taux,
    String? date_enregistrement,
    Pays? pays_from,
    Pays? pays_to,
  }) {
    return Taux(
      id: id ?? this.id,
      date_taux: date_taux ?? this.date_taux,
      pays_id_from: pays_id_from ?? this.pays_id_from,
      pays_id_to: pays_id_to ?? this.pays_id_to,
      taux: taux ?? this.taux,
      date_enregistrement: date_enregistrement ?? this.date_enregistrement,
      pays_from: pays_from ?? this.pays_from,
      pays_to: pays_to ?? this.pays_to,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date_taux': date_taux,
      'pays_id_from': pays_id_from,
      'pays_id_to': pays_id_to,
      'taux': taux,
      'date_enregistrement': date_enregistrement,
      'pays_from': pays_from?.toMap(),
      'pays_to': pays_to?.toMap(),
    };
  }

  factory Taux.fromMap(Map<String, dynamic> map) {
    return Taux(
      id: map['id'] != null ? map['id'] as int : null,
      date_taux: map['date_taux'] != null ? map['date_taux'] as String : null,
      pays_id_from: map['pays_id_from'] != null ? map['pays_id_from'] as int : null,
      pays_id_to: map['pays_id_to'] != null ? map['pays_id_to'] as int : null,
      taux: map['taux'] != null ? map['taux'] as String : null,
      date_enregistrement: map['date_enregistrement'] != null ? map['date_enregistrement'] as String : null,
      pays_from: map['pays_from'] != null ? Pays.fromMap(map['pays_from'] as Map<String, dynamic>) : null,
      pays_to: map['pays_to'] != null ? Pays.fromMap(map['pays_to'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Taux.fromJson(String source) => Taux.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Taux(id: $id, date_taux: $date_taux, pays_id_from: $pays_id_from, pays_id_to: $pays_id_to, taux: $taux, date_enregistrement: $date_enregistrement, pays_from: $pays_from, pays_to: $pays_to)';
  }

  @override
  bool operator ==(covariant Taux other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date_taux == date_taux &&
        other.pays_id_from == pays_id_from &&
        other.pays_id_to == pays_id_to &&
        other.taux == taux &&
        other.date_enregistrement == date_enregistrement &&
        other.pays_from == pays_from &&
        other.pays_to == pays_to;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date_taux.hashCode ^
        pays_id_from.hashCode ^
        pays_id_to.hashCode ^
        taux.hashCode ^
        date_enregistrement.hashCode ^
        pays_from.hashCode ^
        pays_to.hashCode;
  }
}
