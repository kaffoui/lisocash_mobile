// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class Frais {
  int? id;
  String? operation_type;
  String? moyen_paiement;
  String? continent;
  String? from;
  String? to;
  String? frais_pourcentage;
  String? frais_fixe;
  String? created_at;
  String? updated_at;

  Frais({
    this.id,
    this.operation_type,
    this.moyen_paiement,
    this.continent,
    this.from,
    this.to,
    this.frais_pourcentage,
    this.frais_fixe,
    this.created_at,
    this.updated_at,
  });

  Frais copyWith({
    int? id,
    String? operation_type,
    String? moyen_paiement,
    String? continent,
    String? from,
    String? to,
    String? frais_pourcentage,
    String? frais_fixe,
    String? created_at,
    String? updated_at,
  }) {
    return Frais(
      id: id ?? this.id,
      operation_type: operation_type ?? this.operation_type,
      moyen_paiement: moyen_paiement ?? this.moyen_paiement,
      continent: continent ?? this.continent,
      from: from ?? this.from,
      to: to ?? this.to,
      frais_pourcentage: frais_pourcentage ?? this.frais_pourcentage,
      frais_fixe: frais_fixe ?? this.frais_fixe,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'operation_type': operation_type,
      'moyen_paiement': moyen_paiement,
      'continent': continent,
      'from': from,
      'to': to,
      'frais_pourcentage': frais_pourcentage,
      'frais_fixe': frais_fixe,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory Frais.fromMap(Map<String, dynamic> map) {
    return Frais(
      id: map['id'] != null ? map['id'] as int : null,
      operation_type: map['operation_type'] != null ? map['operation_type'] as String : null,
      moyen_paiement: map['moyen_paiement'] != null ? map['moyen_paiement'] as String : null,
      continent: map['continent'] != null ? map['continent'] as String : null,
      from: map['from'] != null ? map['from'] as String : null,
      to: map['to'] != null ? map['to'] as String : null,
      frais_pourcentage: map['frais_pourcentage'] != null ? map['frais_pourcentage'] as String : null,
      frais_fixe: map['frais_fixe'] != null ? map['frais_fixe'] as String : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
      updated_at: map['updated_at'] != null ? map['updated_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Frais.fromJson(String source) => Frais.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Frais(id: $id, operation_type: $operation_type, moyen_paiement: $moyen_paiement, continent: $continent, from: $from, to: $to, frais_pourcentage: $frais_pourcentage, frais_fixe: $frais_fixe, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant Frais other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.operation_type == operation_type &&
        other.moyen_paiement == moyen_paiement &&
        other.continent == continent &&
        other.from == from &&
        other.to == to &&
        other.frais_pourcentage == frais_pourcentage &&
        other.frais_fixe == frais_fixe &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        operation_type.hashCode ^
        moyen_paiement.hashCode ^
        continent.hashCode ^
        from.hashCode ^
        to.hashCode ^
        frais_pourcentage.hashCode ^
        frais_fixe.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
