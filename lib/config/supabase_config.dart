class SupabaseConfig {
  // Prefer passing via --dart-define in production, but we provide defaults
  // so the app works immediately in development.
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://hnckvjquaxwjkymhxsnv.supabase.co',
  );

  // Supabase anon (public) key
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhuY2t2anF1YXh3amt5bWh4c252Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE5NjMzNjgsImV4cCI6MjA5NzUzOTM2OH0.hE5Nm65YZ0zHMZILCmmh11CxWiZjz_qZQsL0LxaSZxg',
  );

  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_SYm-5quOKplkfIgULFXZ8A_mqvAarwq',
  );

  static bool get hasValidConfig =>
      url.isNotEmpty && (publishableKey.isNotEmpty || anonKey.isNotEmpty);
}
