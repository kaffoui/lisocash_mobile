// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'Users.dart';

class Agents {
  int? id_users;
  String? identifiant_unique;
  int? solde;
  String? ip_adresse;
  String? date_enregistrement;

  Users? users;

  Agents({
    this.id_users,
    this.identifiant_unique,
    this.solde,
    this.date_enregistrement,
    this.users,
  });

  Agents copyWith({
    int? id_users,
    String? identifiant_unique,
    int? solde,
    String? date_enregistrement,
    Users? users,
  }) {
    return Agents(
      id_users: id_users ?? this.id_users,
      identifiant_unique: identifiant_unique ?? this.identifiant_unique,
      solde: solde ?? this.solde,
      date_enregistrement: date_enregistrement ?? this.date_enregistrement,
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_users': id_users,
      'identifiant_unique': identifiant_unique,
      'solde': solde,
      'date_enregistrement': date_enregistrement,
      'users': users?.toMap(),
    };
  }

  factory Agents.fromMap(Map<String, dynamic> map) {
    return Agents(
      id_users: map['id_users'] != null ? map['id_users'] as int : null,
      identifiant_unique: map['identifiant_unique'] != null ? map['identifiant_unique'] as String : null,
      solde: map['solde'] != null ? map['solde'] as int : null,
      date_enregistrement: map['date_enregistrement'] != null ? map['date_enregistrement'] as String : null,
      users: map['users'] != null ? Users.fromMap(map['users'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Agents.fromJson(String source) => Agents.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Agents(id_users: $id_users, identifiant_unique: $identifiant_unique, solde: $solde, date_enregistrement: $date_enregistrement, users: $users)';
  }

  @override
  bool operator ==(covariant Agents other) {
    if (identical(this, other)) return true;

    return other.id_users == id_users &&
        other.identifiant_unique == identifiant_unique &&
        other.solde == solde &&
        other.date_enregistrement == date_enregistrement &&
        other.users == users;
  }

  @override
  int get hashCode {
    return id_users.hashCode ^ identifiant_unique.hashCode ^ solde.hashCode ^ date_enregistrement.hashCode ^ users.hashCode;
  }
}
