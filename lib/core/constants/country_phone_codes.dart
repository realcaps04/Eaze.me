class CountryPhoneCode {
  const CountryPhoneCode({
    required this.name,
    required this.isoCode,
    required this.dialCode,
    this.minLength = 7,
    this.maxLength = 12,
  });

  final String name;
  final String isoCode;
  final String dialCode;
  final int minLength;
  final int maxLength;

  String get flagEmoji {
    final code = isoCode.toUpperCase();
    return String.fromCharCodes(
      code.runes.map((unit) => unit + 127397),
    );
  }

  String formatE164(String nationalDigits) => '+$dialCode$nationalDigits';
}

class CountryPhoneCodes {
  static const defaultCountry = CountryPhoneCode(
    name: 'India',
    isoCode: 'IN',
    dialCode: '91',
    minLength: 10,
    maxLength: 10,
  );

  static const List<CountryPhoneCode> all = [
    CountryPhoneCode(name: 'India', isoCode: 'IN', dialCode: '91', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'United States', isoCode: 'US', dialCode: '1', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'United Kingdom', isoCode: 'GB', dialCode: '44', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'United Arab Emirates', isoCode: 'AE', dialCode: '971', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Australia', isoCode: 'AU', dialCode: '61', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Canada', isoCode: 'CA', dialCode: '1', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Singapore', isoCode: 'SG', dialCode: '65', minLength: 8, maxLength: 8),
    CountryPhoneCode(name: 'Malaysia', isoCode: 'MY', dialCode: '60', minLength: 9, maxLength: 10),
    CountryPhoneCode(name: 'Saudi Arabia', isoCode: 'SA', dialCode: '966', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Qatar', isoCode: 'QA', dialCode: '974', minLength: 8, maxLength: 8),
    CountryPhoneCode(name: 'Kuwait', isoCode: 'KW', dialCode: '965', minLength: 8, maxLength: 8),
    CountryPhoneCode(name: 'Oman', isoCode: 'OM', dialCode: '968', minLength: 8, maxLength: 8),
    CountryPhoneCode(name: 'Bahrain', isoCode: 'BH', dialCode: '973', minLength: 8, maxLength: 8),
    CountryPhoneCode(name: 'Pakistan', isoCode: 'PK', dialCode: '92', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Bangladesh', isoCode: 'BD', dialCode: '880', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Sri Lanka', isoCode: 'LK', dialCode: '94', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Nepal', isoCode: 'NP', dialCode: '977', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Germany', isoCode: 'DE', dialCode: '49', minLength: 10, maxLength: 11),
    CountryPhoneCode(name: 'France', isoCode: 'FR', dialCode: '33', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Italy', isoCode: 'IT', dialCode: '39', minLength: 9, maxLength: 10),
    CountryPhoneCode(name: 'Spain', isoCode: 'ES', dialCode: '34', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Netherlands', isoCode: 'NL', dialCode: '31', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Switzerland', isoCode: 'CH', dialCode: '41', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Sweden', isoCode: 'SE', dialCode: '46', minLength: 9, maxLength: 10),
    CountryPhoneCode(name: 'Norway', isoCode: 'NO', dialCode: '47', minLength: 8, maxLength: 8),
    CountryPhoneCode(name: 'Denmark', isoCode: 'DK', dialCode: '45', minLength: 8, maxLength: 8),
    CountryPhoneCode(name: 'Ireland', isoCode: 'IE', dialCode: '353', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Portugal', isoCode: 'PT', dialCode: '351', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Poland', isoCode: 'PL', dialCode: '48', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Turkey', isoCode: 'TR', dialCode: '90', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Russia', isoCode: 'RU', dialCode: '7', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'China', isoCode: 'CN', dialCode: '86', minLength: 11, maxLength: 11),
    CountryPhoneCode(name: 'Japan', isoCode: 'JP', dialCode: '81', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'South Korea', isoCode: 'KR', dialCode: '82', minLength: 9, maxLength: 10),
    CountryPhoneCode(name: 'Hong Kong', isoCode: 'HK', dialCode: '852', minLength: 8, maxLength: 8),
    CountryPhoneCode(name: 'Indonesia', isoCode: 'ID', dialCode: '62', minLength: 9, maxLength: 11),
    CountryPhoneCode(name: 'Philippines', isoCode: 'PH', dialCode: '63', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Thailand', isoCode: 'TH', dialCode: '66', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Vietnam', isoCode: 'VN', dialCode: '84', minLength: 9, maxLength: 10),
    CountryPhoneCode(name: 'New Zealand', isoCode: 'NZ', dialCode: '64', minLength: 9, maxLength: 10),
    CountryPhoneCode(name: 'South Africa', isoCode: 'ZA', dialCode: '27', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Nigeria', isoCode: 'NG', dialCode: '234', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Kenya', isoCode: 'KE', dialCode: '254', minLength: 9, maxLength: 9),
    CountryPhoneCode(name: 'Egypt', isoCode: 'EG', dialCode: '20', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Brazil', isoCode: 'BR', dialCode: '55', minLength: 10, maxLength: 11),
    CountryPhoneCode(name: 'Mexico', isoCode: 'MX', dialCode: '52', minLength: 10, maxLength: 10),
    CountryPhoneCode(name: 'Argentina', isoCode: 'AR', dialCode: '54', minLength: 10, maxLength: 10),
  ];

  static CountryPhoneCode? findByIso(String isoCode) {
    final normalized = isoCode.toUpperCase();
    for (final country in all) {
      if (country.isoCode == normalized) return country;
    }
    return null;
  }
}
