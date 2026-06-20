import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth/auth_service.dart';
import '../services/supabase/supabase_client_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthService(client: client);
});

/// Stream of Supabase auth state changes.
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges();
});

/// Current session (null = signed out OR Supabase not configured).
final sessionProvider = Provider<Session?>((ref) {
  ref.watch(authStateChangesProvider);
  return ref.watch(authServiceProvider).currentSession;
});

final isSignedInProvider = Provider<bool>((ref) => ref.watch(sessionProvider) != null);

