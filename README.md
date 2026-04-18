# PicoClaw Flutter UI

A modern cross-platform UI client for managing the `PicoClaw` service. Designed for clarity, accessibility, high contrast, and TV/remote-friendly viewing.

[English](README.md) | [简体中文](README_zh.md) | [Español](README_es.md) | [Français](README_fr.md) | [Русский](README_ru.md) | [العربية](README_ar.md) | [Deutsch](README_de.md) | [Português](README_pt.md) | [日本語](README_ja.md) | [한국어](README_ko.md) | [Bahasa Indonesia](README_id.md) | [हिन्दी](README_hi.md)

![preview picture](docs\screenshots\main.png)
## 📥 Download & Get Started

Get the latest release from [Releases](https://github.com/sipeed/picoclaw_fui/releases/latest):

| Platform | Format | Bundled Core |
|----------|--------|--------------|
| **Windows** | `.exe` installer / `.zip` | Yes |
| **macOS** | `.dmg` | Yes |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | Yes |
| **Android** (phone / TV) | `.apk` / `.aab` | Yes |

1. Download and install the package for your platform.
2. Launch the app.
3. Press **LAUNCH SERVICE** on the dashboard — the core binary is already bundled, no extra setup needed.
4. More Options to the **Settings** tab.

## ✨ Key Features

- **Minimalist Dashboard**: Clean interface with high-impact typography.
- **Accessible Controls**: Large action buttons optimized for Desktop and Mobile/TV usage.
- **Multiple Color Themes**: 6 professional palettes — Carbon, Slate, Obsidian, Ebony, Nord, and SAKURA.
- **Log Monitoring**: Real-time log display with export support.
- **WebView Integration**: Embedded web management interface with status-aware guidance.
- **Desktop Ready**: System tray, single-instance enforcement, and automatic port conflict resolution.

## 📸 Screenshots

### Dashboard
| Idle Status | Running with SAKURA Theme |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### Network & Management
| Service Not Started Guide | Embedded Web UI (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### Configuration & Themes
| Midnight (Carbon) Selection | Sakura Theme Selection |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ Development

### Prerequisites

- **Flutter SDK** (stable channel)
- **picoclaw core binary** (downloaded via helper script)
- Platform-specific requirements:
  - **Windows**: Visual Studio 2022 with "Desktop development with C++"
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: Xcode with network entitlements

### Build Steps

The build process requires **two steps**: first download the `picoclaw` core binary, then compile the Flutter app.

```bash
# 1. Install dependencies
flutter pub get

# 2. Download picoclaw core binary to app/bin/
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. Build and run (example for Windows)
flutter run -d windows
```

**Why two steps?** The app depends on the native `picoclaw` binary at runtime. The helper script downloads the correct version from GitHub Releases and installs it to `app/bin/` before you run the Flutter app.

### Platform-Specific Builds

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (build universal binary from both architectures)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin_arm64 --platform macos --arch arm64 --build-mode release --no-install-to-build
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin_x86_64 --platform macos --arch x86_64 --build-mode release --no-install-to-build
# Merge into universal binary (lipo -create)
mkdir -p app/bin
for bin in picoclaw picoclaw-launcher; do
  lipo -create "app/bin_arm64/$bin" "app/bin_x86_64/$bin" -output "app/bin/$bin" 2>/dev/null || cp "app/bin_arm64/$bin" "app/bin/$bin"
done
flutter build macos --release

# Linux
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform linux --arch x86_64 --build-mode release --install-to-build || true
flutter build linux --release

# Android (core bundled into APK/AAB via --install-to-build)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

For detailed platform requirements, see [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md).

---

## 🔧 Core Binary Helper

The `tools/fetch_core_local.dart` script downloads the `picoclaw` core binary from GitHub Releases:

```bash
# Default: download for host platform
dart run tools/fetch_core_local.dart

# Specify platform and arch explicitly
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# Use --install-to-build to copy binary into Flutter build output (Android AAB/APK)
--install-to-build
```

**Options:**
- `--repo` — GitHub repo (default: `sipeed/picoclaw`)
- `--tag` — release tag (default: `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (required when `--platform` is set)
- `--install-to-build` — copy binary into Flutter build output directory
- `--github-token` — pass GitHub token for higher rate limits (or set `GITHUB_TOKEN` env var)
- `--dry-run` — preview steps without executing

See `dart run tools/fetch_core_local.dart --help` for full options.

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

