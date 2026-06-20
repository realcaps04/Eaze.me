## Production deployment (Android + iOS)

### 1) Install Flutter + generate platforms

If this project folder does not have `android/`, `ios/`, etc:

```bash
flutter create .
flutter pub get
```

### 2) Configure Supabase (when ready)

- Set `SUPABASE_URL` and `SUPABASE_ANON_KEY` via `--dart-define`:

```bash
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

### 3) Android (Play Store)

- Set applicationId / versionCode / versionName in `android/app/build.gradle`
- Create upload keystore and configure signing
- Build:

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 4) iOS (App Store)

- Open `ios/Runner.xcworkspace` in Xcode
- Set Bundle Identifier, Signing Team, capabilities
- Build:

```bash
flutter build ios --release
```

Then archive + upload via Xcode Organizer / Transporter.

### 5) Recommended production add-ons

- Analytics: Firebase Analytics (or PostHog)
- Crash reporting: Firebase Crashlytics or Sentry
- Push notifications: FCM + APNs (and Supabase edge functions / DB triggers if needed)

