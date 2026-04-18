# PicoClaw Flutter UI

Una interfaz de usuario moderna y multiplataforma para gestionar el servicio `PicoClaw`. Diseñada para claridad, accesibilidad, alto contraste y visualización amigable para TV/mando a distancia.

![Imagen de vista previa](docs/screenshots/main.png)
## 📥 Descarga e inicio

Obtenga la última versión desde [Releases](https://github.com/sipeed/picoclaw_fui/releases/latest):

| Plataforma | Formato | Núcleo incluido |
|------------|---------|----------------|
| **Windows** | `.exe` instalador / `.zip` | Sí |
| **macOS** | `.dmg` | Sí |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | Sí |
| **Android** (teléfono / TV) | `.apk` / `.aab` | Sí |

1. Descargue e instale el paquete para su plataforma.
2. Inicie la aplicación.
3. Presione **LAUNCH SERVICE** en el panel de control — el núcleo ya está incluido, no se necesita configuración adicional.
4. Para más opciones, vaya a la pestaña **Settings**.

## ✨ Características principales

- **Panel de control minimalista**: Interfaz limpia con tipografía de alto impacto.
- **Controles accesibles**: Botones de acción grandes optimizados para escritorio y móvil/TV.
- **Múltiples temas de color**: 6 paletas profesionales — Carbon, Slate, Obsidian, Ebony, Nord y SAKURA.
- **Monitoreo de registros**: Visualización de registros en tiempo real con soporte de exportación.
- **Integración con WebView**: Interfaz de gestión web integrada con orientación consciente del estado.
- **Listo para escritorio**: Bandeja del sistema, aplicación de instancia única y resolución automática de conflictos de puertos.

## 📸 Capturas de pantalla

### Panel de control
| Estado inactivo | Ejecutando con tema SAKURA |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### Red y gestión
| Guía de servicio no iniciado | Interfaz web integrada (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### Configuración y temas
| Selección Midnight (Carbon) | Selección de tema Sakura |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ Desarrollo

### Requisitos previos

- **Flutter SDK** (canal estable)
- **Binario del núcleo PicoClaw** (descargado mediante script auxiliar)
- Requisitos específicos de la plataforma:
  - **Windows**: Visual Studio 2022 con "Desktop development with C++"
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: Xcode con permisos de red

### Pasos de construcción

La construcción requiere **dos pasos**: primero descargar el binario del núcleo `PicoClaw`, luego compilar la aplicación Flutter.

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Descargar el núcleo picoclaw a app/bin/
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. Construir y ejecutar (ejemplo para Windows)
flutter run -d windows
```

### Construcción por plataforma

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (binario universal a partir de ambas arquitecturas)
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

# Android (núcleo incluido en APK/AAB mediante --install-to-build)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

Para requisitos detallados de la plataforma, consulte [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md).

---

## 🔧 Asistente del núcleo binario

El script `tools/fetch_core_local.dart` descarga el binario del núcleo `picoclaw` desde GitHub Releases:

```bash
# Predeterminado: descargar para la plataforma host
dart run tools/fetch_core_local.dart

# Especificar plataforma y arquitectura explícitamente
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# Usar --install-to-build para copiar el binario en la salida de construcción de Flutter
--install-to-build
```

**Opciones:**
- `--repo` — Repositorio de GitHub (predeterminado: `sipeed/picoclaw`)
- `--tag` — Etiqueta de release (predeterminado: `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (requerido cuando se establece `--platform`)
- `--install-to-build` — Copiar el binario al directorio de salida de construcción
- `--github-token` — Pasar token de GitHub para límites más altos (o establecer la variable de entorno `GITHUB_TOKEN`)
- `--dry-run` — Vista previa de los pasos sin ejecutar

Vea `dart run tools/fetch_core_local.dart --help` para la lista completa de opciones.

## 📄 Licencia

Licencia MIT. Vea [LICENSE](LICENSE) para más detalles.
