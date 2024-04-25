// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class Pays {
  int? id;
  String? indicatif;
  String? nom;
  String? code;
  String? monnaie;
  String? symbole_monnaie;
  String? continent;
  String? region;
  String? url_drapeau;
  String? created_at;
  String? updated_at;

  Pays({
    this.id,
    this.indicatif,
    this.nom,
    this.code,
    this.monnaie,
    this.symbole_monnaie,
    this.continent,
    this.region,
    this.url_drapeau,
    this.created_at,
    this.updated_at,
  });

  Pays copyWith({
    int? id,
    String? indicatif,
    String? nom,
    String? code,
    String? monnaie,
    String? symbole_monnaie,
    String? continent,
    String? region,
    String? url_drapeau,
    String? created_at,
    String? updated_at,
  }) {
    return Pays(
      id: id ?? this.id,
      indicatif: indicatif ?? this.indicatif,
      nom: nom ?? this.nom,
      code: code ?? this.code,
      monnaie: monnaie ?? this.monnaie,
      symbole_monnaie: symbole_monnaie ?? this.symbole_monnaie,
      continent: continent ?? this.continent,
      region: region ?? this.region,
      url_drapeau: url_drapeau ?? this.url_drapeau,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'indicatif': indicatif,
      'nom': nom,
      'code': code,
      'monnaie': monnaie,
      'symbole_monnaie': symbole_monnaie,
      'continent': continent,
      'region': region,
      'url_drapeau': url_drapeau,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory Pays.fromMap(Map<String, dynamic> map) {
    return Pays(
      id: map['id'] != null ? map['id'] as int : null,
      indicatif: map['indicatif'] != null ? map['indicatif'] as String : null,
      nom: map['nom'] != null ? map['nom'] as String : null,
      code: map['code'] != null ? map['code'] as String : null,
      monnaie: map['monnaie'] != null ? map['monnaie'] as String : null,
      symbole_monnaie: map['symbole_monnaie'] != null ? map['symbole_monnaie'] as String : null,
      continent: map['continent'] != null ? map['continent'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      url_drapeau: map['url_drapeau'] != null ? map['url_drapeau'] as String : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
      updated_at: map['updated_at'] != null ? map['updated_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pays.fromJson(String source) => Pays.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pays(id: $id, indicatif: $indicatif, nom: $nom, code: $code, monnaie: $monnaie, symbole_monnaie: $symbole_monnaie, continent: $continent, region: $region, url_drapeau: $url_drapeau, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant Pays other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.indicatif == indicatif &&
        other.nom == nom &&
        other.code == code &&
        other.monnaie == monnaie &&
        other.symbole_monnaie == symbole_monnaie &&
        other.continent == continent &&
        other.region == region &&
        other.url_drapeau == url_drapeau &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        indicatif.hashCode ^
        nom.hashCode ^
        code.hashCode ^
        monnaie.hashCode ^
        symbole_monnaie.hashCode ^
        continent.hashCode ^
        region.hashCode ^
        url_drapeau.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
