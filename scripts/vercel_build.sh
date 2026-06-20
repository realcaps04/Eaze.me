#!/usr/bin/env bash
set -euo pipefail

FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"

echo "==> Installing Flutter ($FLUTTER_CHANNEL)..."
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_CHANNEL" --depth 1
fi

export PATH="$PATH:$(pwd)/flutter/bin"

flutter --version
flutter config --enable-web
flutter precache --web
flutter pub get
flutter build web --release --base-href /

# Keep branded loader assets in the web output.
cp web/eazeme_logo.png build/web/eazeme_logo.png 2>/dev/null || true

echo "==> Web build complete: build/web"
