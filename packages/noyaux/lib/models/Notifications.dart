// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'Users.dart';

// ignore_for_file: non_constant_identifier_names

class Notifications {
  int? id;
  int? user_id;
  String? titre;
  String? message;
  String? type_notification;
  String? priorite;
  String? date_enregistrement;

  Users? user;

  Notifications({
    this.id,
    this.user_id,
    this.titre,
    this.message,
    this.type_notification,
    this.priorite,
    this.date_enregistrement,
    this.user,
  });

  Notifications copyWith({
    int? id,
    int? user_id,
    String? titre,
    String? message,
    String? type_notification,
    String? priorite,
    String? date_enregistrement,
    Users? user,
  }) {
    return Notifications(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      titre: titre ?? this.titre,
      message: message ?? this.message,
      type_notification: type_notification ?? this.type_notification,
      priorite: priorite ?? this.priorite,
      date_enregistrement: date_enregistrement ?? this.date_enregistrement,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'titre': titre,
      'message': message,
      'type_notification': type_notification,
      'priorite': priorite,
      'date_enregistrement': date_enregistrement,
      'user': user?.toMap(),
    };
  }

  factory Notifications.fromMap(Map<String, dynamic> map) {
    return Notifications(
      id: map['id'] != null ? map['id'] as int : null,
      user_id: map['user_id'] != null ? map['user_id'] as int : null,
      titre: map['titre'] != null ? map['titre'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      type_notification: map['type_notification'] != null ? map['type_notification'] as String : null,
      priorite: map['priorite'] != null ? map['priorite'] as String : null,
      date_enregistrement: map['date_enregistrement'] != null ? map['date_enregistrement'] as String : null,
      user: map['user'] != null ? Users.fromMap(map['user'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notifications.fromJson(String source) => Notifications.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notifications(id: $id, user_id: $user_id, titre: $titre, message: $message, type_notification: $type_notification, priorite: $priorite, date_enregistrement: $date_enregistrement, user: $user)';
  }

  @override
  bool operator ==(covariant Notifications other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.titre == titre &&
        other.message == message &&
        other.type_notification == type_notification &&
        other.priorite == priorite &&
        other.date_enregistrement == date_enregistrement &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        titre.hashCode ^
        message.hashCode ^
        type_notification.hashCode ^
        priorite.hashCode ^
        date_enregistrement.hashCode ^
        user.hashCode;
  }
}
