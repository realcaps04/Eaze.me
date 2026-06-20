## Eaze.me (Flutter + Supabase)

This repository contains a production-ready Flutter app scaffold for **Eaze.me**:

- Flutter (Material 3), Riverpod, GoRouter
- Supabase (Auth, Storage, Realtime) behind service abstractions
- Premium UI-first implementation (light theme default, Inter font)

### Prerequisites

- Install Flutter (latest stable) and add it to PATH.
- Run:

```bash
flutter doctor
```

### Run the app

```bash
C:\Flutter\bin\flutter run -d chrome
```

Or add `C:\Flutter\bin` to your PATH, then:

```bash
flutter run -d chrome
```

For Android (after installing Android Studio + SDK):

```bash
flutter run -d android
```

### Generating platform folders (if missing)

If this folder was created without `flutter create`, run:

```bash
flutter create .
```

Then re-run `flutter pub get`.

