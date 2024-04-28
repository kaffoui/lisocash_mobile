class Currency {
  String? code;
  double? value;

  Currency({this.code, this.value});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String?,
      value: json['value'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    var r = {'code': code, 'value': value};
    r.removeWhere((key, value) => value == null);
    return r;
  }
}
