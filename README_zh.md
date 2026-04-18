# PicoClaw Flutter UI

现代化跨平台UI客户端，用于管理`PicoClaw`服务。设计注重清晰度、无障碍访问、高对比度，以及适合电视/遥控器操作。

![预览图](docs/screenshots\main.png)
## 📥 下载与开始

从 [Releases](https://github.com/sipeed/picoclaw_fui/releases/latest) 获取最新版本：

| 平台 | 格式 | 内置核心 |
|------|------|---------|
| **Windows** | `.exe` 安装包 / `.zip` | 是 |
| **macOS** | `.dmg` | 是 |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | 是 |
| **Android** (手机 / 电视) | `.apk` / `.aab` | 是 |

1. 下载并安装适合您平台的安装包。
2. 启动应用。
3. 在仪表盘上点击 **LAUNCH SERVICE** — 核心二进制已内置，无需额外设置。
4. 如需更多选项，请前往 **Settings** 标签页。

## ✨ 主要特性

- **极简仪表盘**：简洁界面，高冲击力排版。
- **无障碍控制**：大尺寸操作按钮，针对桌面和移动/电视操作优化。
- **多主题配色**：6种专业配色方案 — Carbon、Slate、Obsidian、Ebony、Nord 和 SAKURA。
- **日志监控**：实时日志显示，支持导出。
- **WebView 集成**：嵌入式Web管理界面，带状态感知引导。
- **桌面就绪**：系统托盘、单实例强制执行、自动端口冲突解决。

## 📸 截图

### 仪表盘
| 空闲状态 | SAKURA 主题运行中 |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### 网络与管理
| 服务未启动引导 | 嵌入式 Web UI (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### 配置与主题
| Midnight (Carbon) 选择 | Sakura 主题选择 |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ 开发

### 环境要求

- **Flutter SDK**（stable 分支）
- **PicoClaw 核心二进制**（通过辅助脚本下载）
- 平台特定要求：
  - **Windows**: Visual Studio 2022 并勾选 "Desktop development with C++"
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: Xcode 及网络权限

### 构建步骤

构建需要**两步**：首先下载 `PicoClaw` 核心二进制，然后编译 Flutter 应用。

```bash
# 1. 安装依赖
flutter pub get

# 2. 下载 picoclaw 核心到 app/bin/
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. 构建并运行（以 Windows 为例）
flutter run -d windows
```

### 各平台构建

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS（从两种架构构建通用二进制）
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

# Android（通过 --install-to-build 将核心打包进 APK/AAB）
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

详细平台要求请参阅 [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md)。

---

## 🔧 核心二进制辅助工具

`tools/fetch_core_local.dart` 脚本从 GitHub Releases 下载 `picoclaw` 核心二进制：

```bash
# 默认：下载当前主机平台版本
dart run tools/fetch_core_local.dart

# 明确指定平台和架构
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# 使用 --install-to-build 将二进制复制到 Flutter 构建输出目录
--install-to-build
```

**选项：**
- `--repo` — GitHub 仓库（默认：`sipeed/picoclaw`）
- `--tag` — 发布标签（默认：`latest`）
- `--platform` — `windows`、`macos`、`linux`、`android`
- `--arch` — `x86_64`、`arm64`（设置 `--platform` 时必填）
- `--install-to-build` — 复制二进制到构建输出目录
- `--github-token` — 传入 GitHub token 以提高速率限制（或设置 `GITHUB_TOKEN` 环境变量）
- `--dry-run` — 预览步骤而不执行

运行 `dart run tools/fetch_core_local.dart --help` 查看完整选项。

## 📄 许可证

MIT 许可证。详见 [LICENSE](LICENSE)。
