import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService({required SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  Session? get currentSession => _client?.auth.currentSession;
  User? get currentUser => _client?.auth.currentUser;

  Stream<AuthState> authStateChanges() {
    final client = _client;
    if (client == null) {
      return const Stream.empty();
    }
    return client.auth.onAuthStateChange;
  }

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      throw const AuthException('Supabase not configured yet.');
    }
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    final client = _client;
    if (client == null) {
      throw const AuthException('Supabase not configured yet.');
    }
    await client.auth.signUp(email: email, password: password, data: data);
  }

  Future<void> signOut() async {
    final client = _client;
    if (client == null) return;
    await client.auth.signOut();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    final client = _client;
    if (client == null) {
      throw const AuthException('Supabase not configured yet.');
    }
    await client.auth.resetPasswordForEmail(email);
  }

  Future<void> signInWithGoogle() async {
    final client = _client;
    if (client == null) {
      throw const AuthException('Supabase not configured yet.');
    }
    await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: null,
    );
  }

  Future<void> signInWithApple() async {
    final client = _client;
    if (client == null) {
      throw const AuthException('Supabase not configured yet.');
    }
    await client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: null,
    );
  }
}
