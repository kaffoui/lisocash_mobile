// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class Configuration {
  int? id;
  String? nom;
  String? type;
  String? priorite;
  String? date_enregistrement;

  Configuration({
    this.id,
    this.nom,
    this.type,
    this.priorite,
    this.date_enregistrement,
  });

  Configuration copyWith({
    int? id,
    String? nom,
    String? type,
    String? priorite,
    String? date_enregistrement,
  }) {
    return Configuration(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      type: type ?? this.type,
      priorite: priorite ?? this.priorite,
      date_enregistrement: date_enregistrement ?? this.date_enregistrement,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nom': nom,
      'type': type,
      'priorite': priorite,
      'date_enregistrement': date_enregistrement,
    };
  }

  factory Configuration.fromMap(Map<String, dynamic> map) {
    return Configuration(
      id: map['id'] != null ? map['id'] as int : null,
      nom: map['nom'] != null ? map['nom'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      priorite: map['priorite'] != null ? map['priorite'] as String : null,
      date_enregistrement: map['date_enregistrement'] != null ? map['date_enregistrement'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Configuration.fromJson(String source) => Configuration.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Configuration(id: $id, nom: $nom, type: $type, priorite: $priorite, date_enregistrement: $date_enregistrement)';
  }

  @override
  bool operator ==(covariant Configuration other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nom == nom &&
        other.type == type &&
        other.priorite == priorite &&
        other.date_enregistrement == date_enregistrement;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nom.hashCode ^ type.hashCode ^ priorite.hashCode ^ date_enregistrement.hashCode;
  }
}
