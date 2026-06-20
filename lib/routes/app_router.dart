import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_providers.dart';
import 'go_router_refresh_stream.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_shell.dart';
import '../screens/splash/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  final refresh = GoRouterRefreshStream(authService.authStateChanges());
  ref.onDispose(refresh.dispose);

  final isSignedIn = ref.watch(isSignedInProvider);

  return GoRouter(
    initialLocation: SplashScreen.routePath,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isSplash = loc == SplashScreen.routePath;
      final isAuthRoute = loc.startsWith('/auth');

      // Allow splash always (it routes to the right place).
      if (isSplash) return null;

      // If not signed in, force auth routes.
      if (!isSignedIn) {
        return isAuthRoute ? null : LoginScreen.routePath;
      }

      // If signed in, prevent going back to auth routes.
      if (isSignedIn && isAuthRoute) return HomeShell.routePath;

      return null;
    },
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'forgot',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      GoRoute(
        path: HomeShell.routePath,
        builder: (context, state) => const HomeShell(),
      ),
    ],
  );
});

