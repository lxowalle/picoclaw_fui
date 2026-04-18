# PicoClaw Flutter UI

`PicoClaw` सेवा को प्रबंधित करने के लिए एक आधुनिक क्रॉस-प्लेटफ़ॉर्म UI क्लाइंट। स्पष्टता, पहुंच, उच्च कंट्रास्ट और TV/रिमोट-अनुकूल देखने के लिए डिज़ाइन किया गया।

![पूर्वावलोकन छवि](docs\screenshots\main.png)
## 📥 डाउनलोड और शुरू करें

[Releases](https://github.com/sipeed/picoclaw_fui/releases/latest) से नवीनतम संस्करण प्राप्त करें:

| प्लेटफ़ॉर्म | प्रारूप | कोर बंडल |
|------------|--------|----------|
| **Windows** | `.exe` इंस्टॉलर / `.zip` | हाँ |
| **macOS** | `.dmg` | हाँ |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | हाँ |
| **Android** (फ़ोन / TV) | `.apk` / `.aab` | हाँ |

1. अपने प्लेटफ़ॉर्म के लिए पैकेज डाउनलोड करें और इंस्टॉल करें।
2. ऐप लॉन्च करें।
3. डैशबोर्ड पर **LAUNCH SERVICE** दबाएं — कोर पहले से बंडल है, कोई अतिरिक्त सेटअप नहीं चाहिए।
4. अधिक विकल्पों के लिए, **Settings** टैब पर जाएं।

## ✨ मुख्य विशेषताएं

- **मिनिमलिस्ट डैशबोर्ड**: उच्च प्रभाव टाइपोग्राफी के साथ साफ इंटरफ़ेस।
- **सुलभ नियंत्रण**: बड़े एक्शन बटन डेस्कटॉप और मोबाइल/TV के लिए अनुकूलित।
- **कई रंग थीम**: 6 पेशेवर पैलेट — Carbon, Slate, Obsidian, Ebony, Nord और SAKURA।
- **लॉग निगरानी**: निर्यात सहायता के साथ वास्तविक समय लॉग प्रदर्शन।
- **WebView एकीकरण**: स्थिति-जागरूक मार्गदर्शन के साथ एम्बेडेड वेब प्रबंधन इंटरफ़ेस।
- **डेस्कटॉप तैयार**: सिस्टम ट्रे, एकल-इंस्टेंस प्रवर्तन और पोर्ट संघर्ष का स्वचालित समाधान।

## 📸 स्क्रीनशॉट

### डैशबोर्ड
| निष्क्रिय स्थिति | SAKURA थीम के साथ चल रहा |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### नेटवर्क और प्रबंधन
| सेवा नहीं शुरू गाइड | एम्बेडेड Web UI (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### कॉन्फ़िगरेशन और थीम
| Midnight (Carbon) चयन | Sakura थीम चयन |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ विकास

### पूर्वापेक्षाएं

- **Flutter SDK** (स्थिर चैनल)
- **PicoClaw कोर बाइनरी** (हेल्पर स्क्रिप्ट द्वारा डाउनलोड किया गया)
- प्लेटफ़ॉर्म-विशिष्ट आवश्यकताएं:
  - **Windows**: "Desktop development with C++" के साथ Visual Studio 2022
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: नेटवर्क अधिकारों वाला Xcode

### निर्माण चरण

निर्माण के लिए **दो चरण** आवश्यक हैं: पहले `PicoClaw` कोर बाइनरी डाउनलोड करें, फिर Flutter ऐप संकलित करें।

```bash
# 1. निर्भरताएं इंस्टॉल करें
flutter pub get

# 2. picoclaw कोर को app/bin/ में डाउनलोड करें
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. बिल्ड और रन करें (Windows उदाहरण)
flutter run -d windows
```

### प्लेटफ़ॉर्म-विशिष्ट बिल्ड

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (दोनों आर्किटेक्चर से यूनिवर्सल बाइनरी)
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

# Android (--install-to-build के माध्यम से APK/AAB में कोर बंडल)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

विस्तृत प्लेटफ़ॉर्म आवश्यकताओं के लिए, [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md) देखें।

---

## 🔧 कोर बाइनरी हेल्पर

`tools/fetch_core_local.dart` स्क्रिप्ट GitHub Releases से `picoclaw` कोर बाइनरी डाउनलोड करती है:

```bash
# डिफ़ॉल्ट: होस्ट प्लेटफ़ॉर्म के लिए डाउनलोड करें
dart run tools/fetch_core_local.dart

# प्लेटफ़ॉर्म और आर्किटेक्चर स्पष्ट रूप से निर्दिष्ट करें
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# Flutter बिल्ड आउटपुट डायरेक्टरी में बाइनरी कॉपी करने के लिए --install-to-build का उपयोग करें
--install-to-build
```

**विकल्प:**
- `--repo` — GitHub रिपॉजिटरी (डिफ़ॉल्ट: `sipeed/picoclaw`)
- `--tag` — रिलीज़ टैग (डिफ़ॉल्ट: `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (`--platform` सेट होने पर आवश्यक)
- `--install-to-build` — बाइनरी को बिल्ड आउटपुट डायरेक्टरी में कॉपी करें
- `--github-token` — उच्च सीमाओं के लिए GitHub टोकन पास करें (या `GITHUB_TOKEN` env वेरिएबल सेट करें)
- `--dry-run` — निष्पादित किए बिना चरणों का पूर्वावलोकन करें

पूर्ण विकल्प सूची के लिए `dart run tools/fetch_core_local.dart --help` देखें।

## 📄 लाइसेंस

MIT लाइसेंस। विवरण के लिए [LICENSE](LICENSE) देखें।
