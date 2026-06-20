class Validators {
  static String? requiredText(String? v, {String label = 'This field'}) {
    if ((v ?? '').trim().isEmpty) return '$label is required';
    return null;
  }

  static String? email(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Enter a valid email';
    return null;
  }

  static String? minLen(String? v, int min, {String label = 'Value'}) {
    final value = v ?? '';
    if (value.isEmpty) return '$label is required';
    if (value.length < min) return 'Minimum $min characters';
    return null;
  }
}

