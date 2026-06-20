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

### Deploy to Vercel (Flutter Web)

This repo includes `vercel.json` + `scripts/vercel_build.sh` so Vercel can:

1. Install Flutter during build
2. Run `flutter build web --release`
3. Serve `build/web`
4. Rewrite SPA routes (`/auth`, etc.) to `index.html`

**Vercel project settings (important):**

- Framework Preset: **Other**
- Root Directory: **.** (repo root)
- Build Command: *(leave empty — uses `vercel.json`)*
- Output Directory: *(leave empty — uses `vercel.json`)*

After pushing `vercel.json`, trigger a **Redeploy** in the Vercel dashboard.

If you still see `404: NOT_FOUND`, open **Deployments → Build Logs** and confirm `build/web/index.html` was produced.

