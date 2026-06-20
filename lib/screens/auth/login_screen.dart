import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_theme.dart';
import '../../widgets/app_text_field.dart';
import '../home/home_shell.dart';

final _loginLoadingProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routePath = '/auth';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    ref.read(_loginLoadingProvider.notifier).state = true;
    try {
      await ref.read(authServiceProvider).signInWithPassword(
            email: _email.text.trim(),
            password: _password.text,
          );
      if (!mounted) return;
      context.go(HomeShell.routePath);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        ref.read(_loginLoadingProvider.notifier).state = false;
      }
    }
  }

  Future<void> _runOAuth(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(_loginLoadingProvider);

    return Scaffold(
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _LoginHero(),
                      const SizedBox(height: 20),
                      const _WorkerShowcase(),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: _GlassCard(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                              AppTextField(
                                controller: _email,
                                label: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icons.mail_outline,
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) return 'Email is required';
                                  if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              AppTextField(
                                controller: _password,
                                label: 'Password',
                                obscureText: _obscure,
                                textInputAction: TextInputAction.done,
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                                validator: (v) {
                                  final value = v ?? '';
                                  if (value.isEmpty) return 'Password is required';
                                  if (value.length < 6) {
                                    return 'Minimum 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => context
                                      .go('${LoginScreen.routePath}/forgot'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.indigo,
                                  ),
                                  child: const Text('Forgot password?'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              _GradientButton(
                                label: 'Log in',
                                loading: loading,
                                onPressed: _signIn,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                      const SizedBox(height: 22),
                      const _OrDivider(),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: _SocialButton(
                              assetPath: 'assets/icons/google.svg',
                              label: 'Google',
                              onPressed: loading
                                  ? null
                                  : () => _runOAuth(
                                        ref
                                            .read(authServiceProvider)
                                            .signInWithGoogle,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _SocialButton(
                              assetPath: 'assets/icons/apple.svg',
                              label: 'Apple',
                              onPressed: loading
                                  ? null
                                  : () => _runOAuth(
                                        ref
                                            .read(authServiceProvider)
                                            .signInWithApple,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => context
                                .go('${LoginScreen.routePath}/register'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.orange,
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginHero extends StatefulWidget {
  const _LoginHero();

  @override
  State<_LoginHero> createState() => _LoginHeroState();
}

class _LoginHeroState extends State<_LoginHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.indigo.withValues(alpha: 0.28),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/eazeme_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Welcome back',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontFamily: AppTheme.displayFont,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Log in to continue to Eaze.me',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
            boxShadow: [
              BoxShadow(
                color: AppColors.indigo.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.7 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: AppColors.accentGradient(),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.30),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: loading ? null : onPressed,
            child: SizedBox(
              height: 56,
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: 0.2,
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

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.assetPath,
    required this.label,
    required this.onPressed,
  });

  final String assetPath;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: SvgPicture.asset(assetPath, width: 22, height: 22),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.85),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _WorkerShowcase extends StatefulWidget {
  const _WorkerShowcase();

  static const _items = <_WorkerItem>[
    _WorkerItem('Electricians', 'assets/images/worker_electrician.png'),
    _WorkerItem('Plumbers', 'assets/images/worker_plumber.png'),
    _WorkerItem('Cleaners', 'assets/images/worker_cleaner.png'),
    _WorkerItem('Technicians', 'assets/images/worker_technician.png'),
    _WorkerItem('Freelancers', 'assets/images/worker_freelancer.png'),
  ];

  @override
  State<_WorkerShowcase> createState() => _WorkerShowcaseState();
}

class _WorkerShowcaseState extends State<_WorkerShowcase> {
  static const _cardWidth = 84.0;
  static const _gap = 10.0;
  static const _step = _cardWidth + _gap;
  static const _cardHeight = 104.0;

  late final ScrollController _scrollController;
  late final List<_WorkerItem> _loopItems;
  Timer? _autoScrollTimer;
  int _dotIndex = 0;

  @override
  void initState() {
    super.initState();
    final items = _WorkerShowcase._items;
    _loopItems = [...items, ...items, ...items];
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.jumpTo(items.length * _step);
    });

    _scrollController.addListener(_syncDotIndex);

    _autoScrollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _advance(),
    );
  }

  void _syncDotIndex() {
    if (!_scrollController.hasClients) return;
    final next = (_scrollController.offset / _step).round() %
        _WorkerShowcase._items.length;
    if (next != _dotIndex) {
      setState(() => _dotIndex = next);
    }
  }

  void _advance() {
    if (!_scrollController.hasClients || !mounted) return;

    final items = _WorkerShowcase._items;
    final oneSetWidth = items.length * _step;
    var next = _scrollController.offset + _step;

    // Seamless loop: always scroll forward, never backward.
    if (next >= oneSetWidth * 2) {
      _scrollController.jumpTo(next - oneSetWidth);
      next = _scrollController.offset + _step;
    }

    _scrollController.animateTo(
      next,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController
      ..removeListener(_syncDotIndex)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Trusted professionals, on demand',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: _cardHeight + 8,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _loopItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: _gap),
            itemBuilder: (context, index) =>
                _WorkerCard(item: _loopItems[index]),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_WorkerShowcase._items.length, (index) {
            final active = index == _dotIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: active
                    ? AppColors.indigo
                    : AppColors.indigo.withValues(alpha: 0.22),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _WorkerItem {
  const _WorkerItem(this.label, this.image);
  final String label;
  final String image;
}

class _WorkerCard extends StatefulWidget {
  const _WorkerCard({required this.item});

  final _WorkerItem item;

  @override
  State<_WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<_WorkerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _kenBurns;

  @override
  void initState() {
    super.initState();
    _kenBurns = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _kenBurns.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 104,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _kenBurns,
              builder: (context, child) {
                final scale = 1.0 + (_kenBurns.value * 0.06);
                return Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: Image.asset(widget.item.image, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                widget.item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: color, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(child: Divider(color: color, thickness: 1)),
      ],
    );
  }
}

class _AuroraBackground extends StatelessWidget {
  const _AuroraBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.canvas),
        child: Stack(
          children: [
            Positioned(
              top: -90,
              right: -70,
              child: _Blob(
                size: 260,
                colors: [
                  AppColors.orange.withValues(alpha: 0.55),
                  AppColors.orange.withValues(alpha: 0.0),
                ],
              ),
            ),
            Positioned(
              top: 120,
              left: -90,
              child: _Blob(
                size: 240,
                colors: [
                  AppColors.indigo.withValues(alpha: 0.45),
                  AppColors.indigo.withValues(alpha: 0.0),
                ],
              ),
            ),
            Positioned(
              bottom: -110,
              right: -60,
              child: _Blob(
                size: 300,
                colors: [
                  AppColors.violet.withValues(alpha: 0.40),
                  AppColors.violet.withValues(alpha: 0.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
