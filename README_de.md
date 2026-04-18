# PicoClaw Flutter UI

Eine moderne plattformübergreifende Benutzeroberfläche zur Verwaltung des `PicoClaw`-Dienstes. Entwickelt für Klarheit, Barrierefreiheit, hohen Kontrast und TV-freundliche Anzeige.

![Vorschaubild](docs\screenshots\main.png)
## 📥 Herunterladen und loslegen

Laden Sie die neueste Version von [Releases](https://github.com/sipeed/picoclaw_fui/releases/latest) herunter:

| Plattform | Format | Kernpaket enthalten |
|-----------|--------|-------------------|
| **Windows** | `.exe` Installer / `.zip` | Ja |
| **macOS** | `.dmg` | Ja |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | Ja |
| **Android** (Telefon / TV) | `.apk` / `.aab` | Ja |

1. Laden Sie das Paket für Ihre Plattform herunter und installieren Sie es.
2. Starten Sie die App.
3. Klicken Sie auf **LAUNCH SERVICE** im Dashboard — der Kern ist bereits enthalten, keine zusätzliche Einrichtung erforderlich.
4. Für weitere Optionen gehen Sie zur Registerkarte **Settings**.

## ✨ Hauptfunktionen

- **Minimalistisches Dashboard**: Saubere Oberfläche mit typografischer Wirkung.
- **Barrierefreie Steuerung**: Große Aktionsschaltflächen, optimiert für Desktop und Mobil/TV.
- **Mehrfarbige Themes**: 6 professionelle Paletten — Carbon, Slate, Obsidian, Ebony, Nord und SAKURA.
- **Protokollüberwachung**: Echtzeit-Protokollanzeige mit Export-Unterstützung.
- **WebView-Integration**: Integrierte Web-Verwaltungsoberfläche mit statusbewusster Anleitung.
- **Desktop-bereit**: Systemleiste, Durchsetzung einer einzelnen Instanz und automatische Auflösung von Portkonflikten.

## 📸 Screenshots

### Dashboard
| Leerlaufstatus | Läuft mit SAKURA-Theme |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### Netzwerk & Verwaltung
| Anleitung wenn Dienst nicht gestartet | Integrierte Web-UI (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### Konfiguration & Themes
| Midnight (Carbon) Auswahl | Sakura-Theme Auswahl |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ Entwicklung

### Voraussetzungen

- **Flutter SDK** (stabiler Kanal)
- **PicoClaw-Kernbinärdatei** (über Hilfsskript heruntergeladen)
- Plattformspezifische Anforderungen:
  - **Windows**: Visual Studio 2022 mit "Desktop development with C++"
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: Xcode mit Netzwerkrechten

### Bauschritte

Der Build erfordert **zwei Schritte**: Zuerst laden Sie die `PicoClaw`-Kernbinärdatei herunter, dann kompilieren Sie die Flutter-App.

```bash
# 1. Abhängigkeiten installieren
flutter pub get

# 2. picoclaw-Kern nach app/bin/ herunterladen
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. Build und Ausführung (Beispiel für Windows)
flutter run -d windows
```

### Plattformspezifische Builds

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (universelle Binärdatei aus beiden Architekturen)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin_arm64 --platform macos --arch arm64 --build-mode release --no-install-to-build
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin_x86_64 --platform macos --arch x86_64 --build-mode release --no-install-to-build
mkdir -p app/bin
for bin in picoclaw picoclaw-launcher; do
  lipo -create "app/bin_arm64/$bin" "app/bin_x86_64/$bin" -output "app/bin/$bin" 2>/dev/null || cp "app/bin_arm64/$bin" "app/bin/$bin"
done
flutter build macos --release

# Linux
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform linux --arch x86_64 --build-mode release --install-to-build || true
flutter build linux --release

# Android (Kern in APK/AAB gebündelt über --install-to-build)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

Detaillierte Plattformanforderungen finden Sie unter [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md).

---

## 🔧 Kernbinär-Helfer

Das Skript `tools/fetch_core_local.dart` lädt die `picoclaw`-Kernbinärdatei von GitHub Releases herunter:

```bash
# Standard: für Host-Plattform herunterladen
dart run tools/fetch_core_local.dart

# Plattform und Architektur explizit angeben
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# --install-to-build verwenden, um die Binärdatei in das Flutter-Build-Ausgabeverzeichnis zu kopieren
--install-to-build
```

**Optionen:**
- `--repo` — GitHub-Repository (Standard: `sipeed/picoclaw`)
- `--tag` — Release-Tag (Standard: `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (erforderlich wenn `--platform` gesetzt ist)
- `--install-to-build` — Binärdatei in das Build-Ausgabeverzeichnis kopieren
- `--github-token` — GitHub-Token für höhere Limits übergeben (oder `GITHUB_TOKEN` Umgebungsvariable setzen)
- `--dry-run` — Schritte ohne Ausführung anzeigen

Siehe `dart run tools/fetch_core_local.dart --help` für die vollständige Optionsliste.

## 📄 Lizenz

MIT-Lizenz. Siehe [LICENSE](LICENSE) für Details.
