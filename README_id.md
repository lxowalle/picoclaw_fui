# PicoClaw Flutter UI

Antarmuka pengguna modern lintas platform untuk mengelola layanan `PicoClaw`. Dirancang untuk kejelasan, aksesibilitas, kontras tinggi, dan tampilan ramah TV/remote.

![Gambar pratinjau](docs/screenshots/main.png)
## 📥 Unduh dan mulai

Dapatkan rilis terbaru dari [Releases](https://github.com/sipeed/picoclaw_fui/releases/latest):

| Platform | Format | Inti termasuk |
|----------|--------|--------------|
| **Windows** | `.exe` installer / `.zip` | Ya |
| **macOS** | `.dmg` | Ya |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | Ya |
| **Android** (ponsel / TV) | `.apk` / `.aab` | Ya |

1. Unduh dan instal paket untuk platform Anda.
2. Luncurkan aplikasi.
3. Tekan **LAUNCH SERVICE** di dasbor — inti sudah termasuk, tidak perlu pengaturan tambahan.
4. Untuk opsi lainnya, buka tab **Settings**.

## ✨ Fitur utama

- **Dasbor minimalis**: Antarmuka bersih dengan tipografi berdampak tinggi.
- **Kontrol dapat diakses**: Tombol aksi besar dioptimalkan untuk desktop dan mobile/TV.
- **Beragam tema warna**: 6 palet profesional — Carbon, Slate, Obsidian, Ebony, Nord, dan SAKURA.
- **Pemantauan log**: Tampilan log waktu nyata dengan dukungan ekspor.
- **Integrasi WebView**: Antarmuka manajemen web tertanam dengan panduan sadar status.
- **Siap desktop**: Baki sistem, penegakan satu instance, dan resolusi konflik port otomatis.

## 📸 Tangkapan layar

### Dasbor
| Status menganggur | Berjalan dengan tema SAKURA |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### Jaringan & manajemen
| Panduan layanan belum dimulai | Web UI tertanam (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### Konfigurasi & tema
| Pemilihan Midnight (Carbon) | Pemilihan tema Sakura |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ Pengembangan

### Prasyarat

- **Flutter SDK** (saluran stabil)
- **Biner inti PicoClaw** (diunduh melalui skrip pembantu)
- Persyaratan khusus platform:
  - **Windows**: Visual Studio 2022 dengan "Desktop development with C++"
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: Xcode dengan hak jaringan

### Langkah pembangunan

Pembangunan memerlukan **dua langkah**: pertama unduh biner inti `PicoClaw`, lalu kompilasi aplikasi Flutter.

```bash
# 1. Instal dependensi
flutter pub get

# 2. Unduh inti picoclaw ke app/bin/
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. Bangun dan jalankan (contoh untuk Windows)
flutter run -d windows
```

### Pembangunan khusus platform

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (biner universal dari kedua arsitektur)
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

# Android (inti dibundle ke APK/AAB via --install-to-build)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

Untuk persyaratan platform detail, lihat [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md).

---

## 🔧 Pembantu biner inti

Skrip `tools/fetch_core_local.dart` mengunduh biner inti `picoclaw` dari GitHub Releases:

```bash
# Default: unduh untuk platform host
dart run tools/fetch_core_local.dart

# Tentukan platform dan arsitektur secara eksplisit
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# Gunakan --install-to-build untuk menyalin biner ke direktori output build Flutter
--install-to-build
```

**Opsi:**
- `--repo` — Repo GitHub (default: `sipeed/picoclaw`)
- `--tag` — Tag rilis (default: `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (diperlukan saat `--platform` disetel)
- `--install-to-build` — Salin biner ke direktori output build
- `--github-token` — Lewati token GitHub untuk batas lebih tinggi (atau setel variabel env `GITHUB_TOKEN`)
- `--dry-run` — Pratinjau langkah tanpa mengeksekusi

Lihat `dart run tools/fetch_core_local.dart --help` untuk daftar opsi lengkap.

## 📄 Lisensi

Lisensi MIT. Lihat [LICENSE](LICENSE) untuk detail.
