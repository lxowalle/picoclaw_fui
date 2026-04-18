# PicoClaw Flutter UI

`PicoClaw`サービスを管理するための最新のクロスプラットフォームUIクライアント。明朗性、アクセシビリティ、高コントラスト、TV/リモートフレンドリーな表示のために設計されています。

![プレビュー画像](docs/screenshots/main.png)
## 📥 ダウンロードと開始

最新バージョンを[Releases](https://github.com/sipeed/picoclaw_fui/releases/latest)から入手：

| プラットフォーム | 形式 | コアバンドル |
|----------|--------|------------|
| **Windows** | `.exe` インストーラー / `.zip` | はい |
| **macOS** | `.dmg` | はい |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | はい |
| **Android** (フォン / TV) | `.apk` / `.aab` | はい |

1. お使いのプラットフォーム用のパッケージをダウンロードしてインストールします。
2. アプリを起動します。
3. ダッシュボードで **LAUNCH SERVICE** を押してください — コアは既にバンドルされており、追加の設定は不要です。
4. その他のオプションについては、**Settings** タブに移動してください。

## ✨ 主な機能

- **ミニマリストダッシュボード**: 高い視覚的インパクトを持つクリーンなインターフェース。
- **アクセシブルなコントロール**: デスクトップとモバイル/TV用に最適化された大きなアクションボタン。
- **複数のカラーテーマ**: 6つのプロフェッショナルパレット — Carbon、Slate、Obsidian、Ebony、Nord、SAKURA。
- **ログ監視**: エクスポート支持的リアルタイムログ表示。
- **WebView統合**: ステータス対応のガイダンスを備えた組み込みWeb管理インターフェース。
- **デスクトップ対応**: システムトレイ、単一インスタンス強制、ポート競合の自動解決。

## 📸 スクリーンショット

### ダッシュボード
| アイドル状態 | SAKURAテーマで実行中 |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### ネットワーク与管理
| サービス未開始ガイド | 組み込みWeb UI (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### 設定とテーマ
| Midnight (Carbon) 選択 | Sakuraテーマ選択 |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ 開発

### 前提条件

- **Flutter SDK**（安定版チャンネル）
- **PicoClawコアバイナリ**（ヘルパースクリプトでダウンロード）
- プラットフォーム固有の要件：
  - **Windows**: "Desktop development with C++"を含むVisual Studio 2022
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: ネットワーク権限を持つXcode

### ビルドステップ

ビルドには**2つのステップ**が必要です：まず`PicoClaw`コアバイナリをダウンロードしてから、Flutterアプリをコンパイルします。

```bash
# 1. 依存関係をインストール
flutter pub get

# 2. picoclawコアをapp/bin/にダウンロード
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. ビルドして実行（Windowsの例）
flutter run -d windows
```

### プラットフォーム固有のビルド

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS（両アーキテクチャからのユニバーサルバイナリ）
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

# Android（--install-to-buildでAPK/AABにコアをバンドル）
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

詳細なプラットフォーム要件は[docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md)を参照してください。

---

## 🔧 コアバイナリヘルパー

`tools/fetch_core_local.dart`スクリプトはGitHub Releasesから`picoclaw`コアバイナリをダウンロードします：

```bash
# デフォルト：ホストプラットフォーム用にダウンロード
dart run tools/fetch_core_local.dart

# プラットフォームとアーキテクチャを明示的に指定
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# --install-to-buildを使用してFlutterビルド出力ディレクトリにバイナリをコピー
--install-to-build
```

**オプション：**
- `--repo` — GitHubリポジトリ（デフォルト：`sipeed/picoclaw`）
- `--tag` — リリースタグ（デフォルト：`latest`）
- `--platform` — `windows`、`macos`、`linux`、`android`
- `--arch` — `x86_64`、`arm64`（`--platform`設定時に必要）
- `--install-to-build` — バイナリを構築出力ディレクトリにコピー
- `--github-token` — 高いレート制限用のGitHubトークン（または`GITHUB_TOKEN`環境変数を設定）
- `--dry-run` — 実行せずにステップをプレビュー

全オプションリストは`dart run tools/fetch_core_local.dart --help`を参照してください。

## 📄 ライセンス

MITライセンス。詳細については[LICENSE](LICENSE)を参照してください。
