/// A dialing country for the phone-number field.
class Country {
  const Country({
    required this.isoCode,
    required this.dialCode,
  });

  /// 2-letter ISO code, e.g. "SA".
  final String isoCode;

  /// E.164 dialing prefix, e.g. "+966".
  final String dialCode;

  @override
  bool operator ==(Object other) =>
      other is Country &&
      other.isoCode == isoCode &&
      other.dialCode == dialCode;

  @override
  int get hashCode => Object.hash(isoCode, dialCode);
}

/// Supported countries for the picker. Replace with a full list / API later.
class Countries {
  Countries._();

  static const Country saudiArabia = Country(isoCode: 'SA', dialCode: '+966');
  static const Country egypt = Country(isoCode: 'EG', dialCode: '+20');
  static const Country uae = Country(isoCode: 'AE', dialCode: '+971');

  static const List<Country> all = [saudiArabia, egypt, uae];

  static const Country fallback = saudiArabia;
}
