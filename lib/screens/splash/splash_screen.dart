import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/auth_providers.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_theme.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/brand_loading_bar.dart';
import '../auth/login_screen.dart';
import '../home/home_shell.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const routePath = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _loopController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<double> _glowRotation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.72, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );
    _logoFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    );
    _textFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.35, 1, curve: Curves.easeOut),
    );

    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _glowRotation = Tween<double>(begin: 0, end: 1).animate(_loopController);

    unawaited(_entryController.forward());
    unawaited(_boot());
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final signedIn = ref.read(isSignedInProvider);
    context.go(signedIn ? HomeShell.routePath : LoginScreen.routePath);
  }

  @override
  void dispose() {
    _entryController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _SplashAuroraBackground(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([_entryController, _loopController]),
                    builder: (context, child) {
                      final pulse = 1 + (math.sin(_loopController.value * math.pi * 2) * 0.03);
                      return Transform.scale(
                        scale: _logoScale.value * pulse,
                        child: Opacity(opacity: _logoFade.value, child: child),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _glowRotation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _glowRotation.value * math.pi * 2,
                              child: Container(
                                width: 108,
                                height: 108,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    colors: [
                                      AppColors.orange.withValues(alpha: 0.0),
                                      AppColors.orange.withValues(alpha: 0.55),
                                      AppColors.indigo.withValues(alpha: 0.55),
                                      AppColors.violet.withValues(alpha: 0.35),
                                      AppColors.orange.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const AppLogo(size: 80),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  FadeTransition(
                    opacity: _textFade,
                    child: Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontFamily: AppTheme.displayFont,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FadeTransition(
                    opacity: _textFade,
                    child: const BrandLoadingBar(width: 180, height: 6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashAuroraBackground extends StatelessWidget {
  const _SplashAuroraBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.canvas),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -80,
              child: _Blob(
                size: 280,
                colors: [
                  AppColors.orange.withValues(alpha: 0.50),
                  AppColors.orange.withValues(alpha: 0.0),
                ],
              ),
            ),
            Positioned(
              top: 140,
              left: -100,
              child: _Blob(
                size: 260,
                colors: [
                  AppColors.indigo.withValues(alpha: 0.42),
                  AppColors.indigo.withValues(alpha: 0.0),
                ],
              ),
            ),
            Positioned(
              bottom: -120,
              right: -70,
              child: _Blob(
                size: 320,
                colors: [
                  AppColors.violet.withValues(alpha: 0.38),
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
