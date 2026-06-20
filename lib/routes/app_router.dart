import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_providers.dart';
import 'go_router_refresh_stream.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  final refresh = GoRouterRefreshStream(authService.authStateChanges());
  ref.onDispose(refresh.dispose);

  final isSignedIn = ref.watch(isSignedInProvider);

  return GoRouter(
    initialLocation: LoginScreen.routePath,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isAuthRoute = loc.startsWith('/auth');

      if (loc == '/') {
        return isSignedIn ? HomeShell.routePath : LoginScreen.routePath;
      }

      if (!isSignedIn) {
        return isAuthRoute ? null : LoginScreen.routePath;
      }

      if (isSignedIn && isAuthRoute) return HomeShell.routePath;

      return null;
    },
    routes: [
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
