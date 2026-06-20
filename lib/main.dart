import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'config/supabase_config.dart';
import 'core/supabase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // UI-first scaffold: you can fill these later.
  // The app can still run without Supabase init (mock mode),
  // but production should always initialize Supabase.
  if (SupabaseConfig.hasValidConfig) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    isSupabaseInitialized = true;
  }

  runApp(const ProviderScope(child: EazeMeApp()));
}

