# PicoClaw Flutter UI

Une interface utilisateur moderne et multiplateforme pour gérer le service `PicoClaw`. Conçue pour la clarté, l'accessibilité, le contraste élevé et la visualisation adaptée à la télévision/à la télécommande.

![Image d'aperçu](docs/screenshots\main.png)
## 📥 Téléchargement et démarrage

Obtenez la dernière version depuis [Releases](https://github.com/sipeed/picoclaw_fui/releases/latest):

| Plateforme | Format | Cœur inclus |
|------------|--------|-------------|
| **Windows** | `.exe` installateur / `.zip` | Oui |
| **macOS** | `.dmg` | Oui |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | Oui |
| **Android** (téléphone / TV) | `.apk` / `.aab` | Oui |

1. Téléchargez et installez le package pour votre plateforme.
2. Lancez l'application.
3. Appuyez sur **LAUNCH SERVICE** sur le tableau de bord — le binaire cœur est déjà inclus, aucune configuration supplémentaire nécessaire.
4. Pour plus d'options, allez dans l'onglet **Settings**.

## ✨ Fonctionnalités principales

- **Tableau de bord minimaliste**: Interface épurée avec typographie à fort impact.
- **Contrôles accessibles**: Grands boutons d'action optimisés pour le bureau et le mobile/TV.
- **Thèmes de couleurs multiples**: 6 palettes professionnelles — Carbon, Slate, Obsidian, Ebony, Nord et SAKURA.
- **Surveillance des journaux**: Affichage des journaux en temps réel avec support d'exportation.
- **Intégration WebView**: Interface de gestion web intégrée avec conseils contextuels.
- **Prêt pour le bureau**: Barre système, application d'instance unique et résolution automatique des conflits de port.

## 📸 Captures d'écran

### Tableau de bord
| État inactif | En cours avec le thème SAKURA |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### Réseau et gestion
| Guide service non démarré | Interface Web intégrée (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### Configuration et thèmes
| Sélection Midnight (Carbon) | Sélection thème Sakura |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ Développement

### Prérequis

- **Flutter SDK** (chaîne stable)
- **Binaire cœur PicoClaw** (téléchargé via le script assistant)
- Exigences spécifiques à la plateforme :
  - **Windows**: Visual Studio 2022 avec "Desktop development with C++"
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: Xcode avec droits réseau

### Étapes de construction

La construction nécessite **deux étapes** : d'abord télécharger le binaire cœur `PicoClaw`, puis compiler l'application Flutter.

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Télécharger le cœur picoclaw vers app/bin/
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. Construire et exécuter (exemple pour Windows)
flutter run -d windows
```

### Construction par plateforme

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (binaire universel à partir des deux architectures)
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

# Android (cœur intégré dans APK/AAB via --install-to-build)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

Pour les exigences détaillées par plateforme, consultez [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md).

---

## 🔧 Assistant du binaire cœur

Le script `tools/fetch_core_local.dart` télécharge le binaire cœur `picoclaw` depuis GitHub Releases :

```bash
# Par défaut : télécharger pour la plateforme hôte
dart run tools/fetch_core_local.dart

# Spécifier explicitement la plateforme et l'architecture
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# Utiliser --install-to-build pour copier le binaire dans les sorties de construction Flutter
--install-to-build
```

**Options :**
- `--repo` — Dépôt GitHub (par défaut : `sipeed/picoclaw`)
- `--tag` — Tag de release (par défaut : `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (requis quand `--platform` est défini)
- `--install-to-build` — Copier le binaire dans le répertoire de sortie de construction
- `--github-token` — Passer le token GitHub pour des limites plus élevées (ou définir la variable d'environnement `GITHUB_TOKEN`)
- `--dry-run` — Aperçu des étapes sans exécution

Voir `dart run tools/fetch_core_local.dart --help` pour la liste complète des options.

## 📄 Licence

Licence MIT. Voir [LICENSE](LICENSE) pour les détails.
