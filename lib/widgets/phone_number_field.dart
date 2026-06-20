import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/country_phone_codes.dart';
import '../themes/app_colors.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    this.initialCountry = CountryPhoneCodes.defaultCountry,
    this.label = 'Phone number',
    this.textInputAction,
    this.validator,
    this.onCountryChanged,
  });

  final TextEditingController controller;
  final CountryPhoneCode initialCountry;
  final String label;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<CountryPhoneCode>? onCountryChanged;

  @override
  State<PhoneNumberField> createState() => PhoneNumberFieldState();
}

class PhoneNumberFieldState extends State<PhoneNumberField> {
  static const _radius = 18.0;
  static const _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(_radius)),
    borderSide: BorderSide(color: Color(0xFFE53935), width: 1.5),
  );

  late CountryPhoneCode _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
  }

  CountryPhoneCode get selectedCountry => _selectedCountry;

  String nationalDigits() =>
      widget.controller.text.replaceAll(RegExp(r'\D'), '');

  String fullE164() => _selectedCountry.formatE164(nationalDigits());

  Future<void> _pickCountry() async {
    FocusScope.of(context).unfocus();
    final picked = await showModalBottomSheet<CountryPhoneCode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CountryPickerSheet(selected: _selectedCountry),
    );
    if (picked == null || !mounted) return;
    setState(() => _selectedCountry = picked);
    widget.onCountryChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(_selectedCountry.maxLength),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.label,
        errorStyle: const TextStyle(
          height: 0,
          fontSize: 0,
          color: Colors.transparent,
        ),
        errorBorder: _errorBorder,
        focusedErrorBorder: _errorBorder,
        prefixIcon: InkWell(
          onTap: _pickCountry,
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(_radius),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 14, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedCountry.flagEmoji,
                  style: const TextStyle(fontSize: 22, height: 1),
                ),
                const SizedBox(width: 4),
                Text(
                  '+${_selectedCountry.dialCode}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                Container(
                  width: 1,
                  height: 22,
                  margin: const EdgeInsets.only(left: 4),
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({required this.selected});

  final CountryPhoneCode selected;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _search = TextEditingController();
  late List<CountryPhoneCode> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List<CountryPhoneCode>.from(CountryPhoneCodes.all);
    _search.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _search.removeListener(_applyFilter);
    _search.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final query = _search.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = List<CountryPhoneCode>.from(CountryPhoneCodes.all);
        return;
      }
      _filtered = CountryPhoneCodes.all.where((country) {
        return country.name.toLowerCase().contains(query) ||
            country.isoCode.toLowerCase().contains(query) ||
            country.dialCode.contains(query.replaceAll('+', ''));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Select country',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: 'Search country or code',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: AppColors.canvas,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                    itemBuilder: (context, index) {
                      final country = _filtered[index];
                      final isSelected = country.isoCode == widget.selected.isoCode;

                      return ListTile(
                        leading: Text(
                          country.flagEmoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                        title: Text(
                          country.name,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          '+${country.dialCode}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? AppColors.indigo
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: isSelected,
                        onTap: () => Navigator.of(context).pop(country),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
