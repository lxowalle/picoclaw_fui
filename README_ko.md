# PicoClaw Flutter UI

`PicoClaw` 서비스를 관리하기 위한 최신 크로스 플랫폼 UI 클라이언트. 명확성, 접근성, 높은 대비, TV/리모컨에 친숙한 보기를 위해 설계되었습니다.

![미리보기 이미지](docs\screenshots\main.png)
## 📥 다운로드 및 시작

[Releases](https://github.com/sipeed/picoclaw_fui/releases/latest)에서 최신 버전을 받으세요:

| 플랫폼 | 형식 | 코어 번들 |
|--------|------|----------|
| **Windows** | `.exe` 인스톨러 / `.zip` | 예 |
| **macOS** | `.dmg` | 예 |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | 예 |
| **Android** (폰 / TV) | `.apk` / `.aab` | 예 |

1. 플랫폼에 맞는 패키지를 다운로드하여 설치하세요.
2. 앱을 실행하세요.
3. 대시보드에서 **LAUNCH SERVICE**를 누르세요 — 코어가 이미 번들되어 있어 추가 설정이 필요 없습니다.
4. 더 많은 옵션은 **Settings** 탭으로 이동하세요.

## ✨ 주요 기능

- **미니멀리스트 대시보드**: 높은 임팩트의 타이포그래피를 갖춘 깔끔한 인터페이스.
- **접근 가능한 컨트롤**: 데스크톱 및 모바일/TV 사용에 최적화된 큰 액션 버튼.
- **다양한 컬러 테마**: 6가지 전문 팔레트 — Carbon, Slate, Obsidian, Ebony, Nord 및 SAKURA.
- **로그 모니터링**: 내보내기支持的 실시간 로그 표시.
- **WebView 통합**: 상태 인식 가이드가内置된 웹 관리 인터페이스.
- **데스크톱 준비 완료**: 시스템 트레이, 단일 인스턴스 적용, 포트 충돌 자동 해결.

## 📸 스크린샷

### 대시보드
| 유휴 상태 | SAKURA 테마 실행 중 |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### 네트워크 및 관리
| 서비스 미시작 가이드 | 내장 Web UI (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### 구성 및 테마
| Midnight (Carbon) 선택 | Sakura 테마 선택 |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ 개발

### 전제 조건

- **Flutter SDK** (안정 채널)
- **PicoClaw 코어 바이너리** (헬퍼 스크립트로 다운로드)
- 플랫폼 특정 요구 사항:
  - **Windows**: "Desktop development with C++"가 포함된 Visual Studio 2022
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: 네트워크 권한이 있는 Xcode

### 빌드 단계

빌드에는 **두 단계**가 필요합니다: 먼저 `PicoClaw` 코어 바이너리를 다운로드한 다음 Flutter 앱을 컴파일합니다.

```bash
# 1. 의존성 설치
flutter pub get

# 2. picoclaw 코어를 app/bin/으로 다운로드
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. 빌드 및 실행 (Windows 예시)
flutter run -d windows
```

### 플랫폼별 빌드

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (두 아키텍처의 범용 바이너리)
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

# Android (--install-to-build로 APK/AAB에 코어 번들)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

세부 플랫폼 요구 사항은 [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md)를 참조하세요.

---

## 🔧 코어 바이너리 헬퍼

`tools/fetch_core_local.dart` 스크립트가 GitHub Releases에서 `picoclaw` 코어 바이너리를 다운로드합니다:

```bash
# 기본: 호스트 플랫폼용 다운로드
dart run tools/fetch_core_local.dart

# 플랫폼 및 아키텍처 명시적 지정
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# --install-to-build를 사용하여 Flutter 빌드 출력 디렉토리에 바이너리 복사
--install-to-build
```

**옵션:**
- `--repo` — GitHub 저장소 (기본값: `sipeed/picoclaw`)
- `--tag` —.release 태그 (기본값: `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (`--platform` 설정 시 필수)
- `--install-to-build` — 바이너리를 빌드 출력 디렉토리에 복사
- `--github-token` — 더 높은 속도 제한을 위한 GitHub 토큰 (또는 `GITHUB_TOKEN` 환경 변수 설정)
- `--dry-run` — 실행 없이 단계 미리보기

전체 옵션 목록은 `dart run tools/fetch_core_local.dart --help`를 참조하세요.

## 📄 라이선스

MIT 라이선스. 자세한 내용은 [LICENSE](LICENSE)를 참조하세요.
