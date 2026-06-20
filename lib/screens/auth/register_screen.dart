import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/country_phone_codes.dart';
import '../../providers/auth_providers.dart';
import '../../themes/app_colors.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/phone_number_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/terms_and_conditions_sheet.dart';
import 'login_screen.dart';

final _registerLoadingProvider = StateProvider<bool>((ref) => false);

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
final _namePattern = RegExp(r"^[a-zA-Z][a-zA-Z\s'.-]{1,}$");

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFieldKey = GlobalKey<PhoneNumberFieldState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  late final TapGestureRecognizer _termsTapRecognizer;

  bool _obscure = true;
  bool _agree = false;
  CountryPhoneCode _selectedCountry = CountryPhoneCodes.defaultCountry;

  @override
  void initState() {
    super.initState();
    _termsTapRecognizer = TapGestureRecognizer()
      ..onTap = () => showTermsAndConditionsSheet(context);
  }

  @override
  void dispose() {
    _termsTapRecognizer.dispose();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validateFullName(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return 'Full name is required';
    if (trimmed.length < 2) return 'Enter at least 2 characters';
    if (!_namePattern.hasMatch(trimmed)) return 'Enter a valid full name';
    return null;
  }

  String? _validateEmail(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return 'Email is required';
    if (!_emailPattern.hasMatch(trimmed)) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Phone number is required';
    if (digits.length < _selectedCountry.minLength ||
        digits.length > _selectedCountry.maxLength) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Please confirm your password';
    if (value != _password.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Conditions')),
      );
      return;
    }

    final phoneE164 = _phoneFieldKey.currentState?.fullE164() ??
        _selectedCountry.formatE164(_phone.text.replaceAll(RegExp(r'\D'), ''));

    ref.read(_registerLoadingProvider.notifier).state = true;
    try {
      await ref.read(authServiceProvider).signUp(
            email: _email.text.trim(),
            password: _password.text,
            data: {
              'full_name': _fullName.text.trim(),
              'phone': phoneE164,
              'country_code': _selectedCountry.isoCode,
              'terms_accepted_at': DateTime.now().toUtc().toIso8601String(),
            },
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please verify your email.')),
      );
      context.go(LoginScreen.routePath);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      ref.read(_registerLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loading = ref.watch(_registerLoadingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Join Eaze.me',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create a premium experience in minutes.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        controller: _fullName,
                        label: 'Full name',
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        validator: _validateFullName,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _email,
                        label: 'Email',
                        prefixIcon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 12),
                      PhoneNumberField(
                        key: _phoneFieldKey,
                        controller: _phone,
                        initialCountry: _selectedCountry,
                        textInputAction: TextInputAction.next,
                        validator: _validatePhone,
                        onCountryChanged: (country) {
                          setState(() => _selectedCountry = country);
                          _formKey.currentState?.validate();
                        },
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _password,
                        label: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _confirm,
                        label: 'Confirm password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _agree,
                              onChanged: (v) => setState(() => _agree = v ?? false),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  style: theme.textTheme.bodyMedium,
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: AppColors.indigo,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.indigo,
                                      ),
                                      recognizer: _termsTapRecognizer,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      PrimaryButton(
                        label: 'Create account',
                        loading: loading,
                        onPressed: _register,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.go(LoginScreen.routePath),
                        child: const Text('Already have an account? Login'),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
