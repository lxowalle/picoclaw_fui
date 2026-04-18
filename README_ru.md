# PicoClaw Flutter UI

Современный кроссплатформенный клиент для управления сервисом `PicoClaw`. Разработан для ясности, доступности, высокой контрастности и удобного просмотра на телевизоре/пульте.

![Превью](docs/screenshots/main.png)
## 📥 Скачивание и начало работы

Получите последнюю версию из [Releases](https://github.com/sipeed/picoclaw_fui/releases/latest):

| Платформа | Формат | Ядро в комплекте |
|-----------|--------|-----------------|
| **Windows** | `.exe` установщик / `.zip` | Да |
| **macOS** | `.dmg` | Да |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | Да |
| **Android** (телефон / ТВ) | `.apk` / `.aab` | Да |

1. Скачайте и установите пакет для вашей платформы.
2. Запустите приложение.
3. Нажмите **LAUNCH SERVICE** на панели управления — ядро уже в комплекте, дополнительная настройка не требуется.
4. Для дополнительных параметров перейдите на вкладку **Settings**.

## ✨ Основные функции

- **Минималистичная панель управления**: Чистый интерфейс с выразительной типографикой.
- **Доступные элементы управления**: Крупные кнопки действий, оптимизированные для настольных и мобильных/ТВ-устройств.
- **Несколько цветовых тем**: 6 профессиональных палитр — Carbon, Slate, Obsidian, Ebony, Nord и SAKURA.
- **Мониторинг журналов**: Отображение журналов в реальном времени с поддержкой экспорта.
- **Интеграция WebView**: Встроенный веб-интерфейс управления с контекстными подсказками.
- **Готовность к настольному использованию**: Системный трей, принудительное выполнение одного экземпляра и автоматическое разрешение конфликтов портов.

## 📸 Скриншоты

### Панель управления
| Состояние простоя | Работа с темой SAKURA |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### Сеть и управление
| Руководство при не запущенном сервисе | Встроенный веб-интерфейс (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### Конфигурация и темы
| Выбор Midnight (Carbon) | Выбор темы Sakura |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ Разработка

### Требования

- **Flutter SDK** (стабильный канал)
- **Исполняемый файл ядра PicoClaw** (загружается через вспомогательный скрипт)
- Требования для конкретных платформ:
  - **Windows**: Visual Studio 2022 с "Desktop development with C++"
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: Xcode с сетевыми правами

### Этапы сборки

Сборка требует **двух этапов**: сначала загрузите исполняемый файл ядра `PicoClaw`, затем скомпилируйте приложение Flutter.

```bash
# 1. Установить зависимости
flutter pub get

# 2. Загрузить ядро picoclaw в app/bin/
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. Собрать и запустить (пример для Windows)
flutter run -d windows
```

### Сборка для конкретных платформ

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (универсальный бинарный файл из двух архитектур)
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

# Android (ядро встроено в APK/AAB через --install-to-build)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

Подробные требования для платформ см. в [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md).

---

## 🔧 Помощник для загрузки ядра

Скрипт `tools/fetch_core_local.dart` загружает исполняемый файл ядра `picoclaw` из GitHub Releases:

```bash
# По умолчанию: загрузить для платформы хоста
dart run tools/fetch_core_local.dart

# Явно указать платформу и архитектуру
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# Использовать --install-to-build для копирования ядра в выходной каталог сборки Flutter
--install-to-build
```

**Параметры:**
- `--repo` — GitHub-репозиторий (по умолчанию: `sipeed/picoclaw`)
- `--tag` — тег релиза (по умолчанию: `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (обязателен при указании `--platform`)
- `--install-to-build` — копировать ядро в каталог вывода сборки
- `--github-token` — передать токен GitHub для более высоких лимитов (или установить переменную окружения `GITHUB_TOKEN`)
- `--dry-run` — просмотреть шаги без выполнения

См. `dart run tools/fetch_core_local.dart --help` для полного списка параметров.

## 📄 Лицензия

MIT License. Подробности см. в [LICENSE](LICENSE).
