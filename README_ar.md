# واجهة PicoClaw الرسومية

واجهة مستخدم عصرية ومتعددة المنصات لإدارة خدمة `PicoClaw`. مصممة للوضوح وإمكانية الوصول والتباين العالي ومشاهدة صديقة للتلفزيون/الريموت.

![صورة المعاينة](docs/screenshots\main.png)
## 📥 التحميل والبدء

احصل على أحدث إصدار من [Releases](https://github.com/sipeed/picoclaw_fui/releases/latest):

| النظام | التنسيق | النواة مضمنة |
|--------|---------|-------------|
| **Windows** | `.exe` مثبت / `.zip` | نعم |
| **macOS** | `.dmg` | نعم |
| **Linux** (Ubuntu / Deepin / Debian) | `.deb` | نعم |
| **Android** (هاتف / تلفزيون) | `.apk` / `.aab` | نعم |

1. قم بتحميل وتثبيت الحزمة لنظامك.
2. запустите приложение.
3. اضغط على **LAUNCH SERVICE** في لوحة التحكم — النواة مضمنة بالفعل، لا حاجة لإعداد إضافي.
4. للمزيد من الخيارات، انتقل إلى تبويب **Settings**.

## ✨ الميزات الرئيسية

- **لوحة تحكم بسيطة**: واجهة نظيفة بطباعة عالية التأثير.
- **عناصر تحكم يمكن الوصول إليها**: أزرار كبيرة محسنة للاستخدام على سطح المكتب والهاتف والتلفزيون.
- **مواضيع ألوان متعددة**: 6 أدوات احترافية — Carbon وSlate وObsidian وEbony وNord وSAKURA.
- **مراقبة السجلات**: عرض سجلات في الوقت الفعلي مع دعم التصدير.
- **تكامل WebView**: واجهة إدارة ويب مدمجة مع إرشادات مدركة للحالة.
- **جاهز لسطح المكتب**: علبة النظام، فرض مثيل واحد، وحل تلقائي لتعارض المنافذ.

## 📸 لقطات الشاشة

### لوحة التحكم
| الحالة الخاملة | يعمل مع موضوع SAKURA |
| :---: | :---: |
| ![Dashboard Idle](docs/screenshots/dashboard_idle.png) | ![Dashboard Running](docs/screenshots/dashboard_running_sakura.png) |

### الشبكة والإدارة
| دليل عدم بدء الخدمة | واجهة الويب المدمجة (Sakura) |
| :---: | :---: |
| ![Network Not Started](docs/screenshots/network_not_started.png) | ![Network Sakura](docs/screenshots/network_sakura.png) |

### الإعدادات والمواضيع
| اختيار Midnight (Carbon) | اختيار موضوع Sakura |
| :---: | :---: |
| ![Settings Carbon](docs/screenshots/settings_dark.png) | ![Settings Sakura](docs/screenshots/settings_sakura.png) |

## 🛠️ التطوير

### المتطلبات المسبقة

- **Flutter SDK** (القناة المستقرة)
- **نواة PicoClaw** (يتم تحميلها عبر سكريبت مساعد)
- متطلبات خاصة بالمنصة:
  - **Windows**: Visual Studio 2022 مع "Desktop development with C++"
  - **Linux**: `libayatana-appindicator3-dev libgtk-3-dev pkg-config`
  - **macOS**: Xcode مع صلاحيات الشبكة

### خطوات البناء

يتطلب البناء **خطوتين**: أولاً تحميل نواة `PicoClaw`، ثم تجميع تطبيق Flutter.

```bash
# 1. تثبيت التبعيات
flutter pub get

# 2. تحميل نواة picoclaw إلى app/bin/
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin

# 3. البناء والتشغيل (مثال لـ Windows)
flutter run -d windows
```

### البناء الخاص بالمنصة

```bash
# Windows
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform windows --arch x86_64 --build-mode release --install-to-build
flutter build windows --release

# macOS (ثنائي شامل من كلتا البنيتين)
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

# Android (النواة مضمنة في APK/AAB عبر --install-to-build)
dart run tools/fetch_core_local.dart --repo sipeed/picoclaw --tag latest --out-dir app/bin --platform android --arch arm64 --build-mode release --install-to-build
flutter build appbundle --release --target-platform android-arm,android-arm64
flutter build apk --release --target-platform android-arm,android-arm64
```

للحصول على متطلبات المنصة التفصيلية، راجع [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md).

---

## 🔧 مساعد النواة

سكريبت `tools/fetch_core_local.dart` يحمّل نواة `picoclaw` من إصدارات GitHub:

```bash
# افتراضي: تحميل لمنصة المضيف
dart run tools/fetch_core_local.dart

# تحديد المنصة والبنية صراحة
dart run tools/fetch_core_local.dart \
    --repo sipeed/picoclaw \
    --tag latest \
    --out-dir app/bin \
    --platform windows \
    --arch x86_64

# استخدام --install-to-build لنسخ النواة إلى مخرجات بناء Flutter
--install-to-build
```

**الخيارات:**
- `--repo` — مستودع GitHub (افتراضي: `sipeed/picoclaw`)
- `--tag` — وسم الإصدار (افتراضي: `latest`)
- `--platform` — `windows`, `macos`, `linux`, `android`
- `--arch` — `x86_64`, `arm64` (مطلوب عند تحديد `--platform`)
- `--install-to-build` — نسخ النواة إلى دليل مخرجات البناء
- `--github-token` — تمرير رمز GitHub لحدود أعلى (أو تعيين متغير البيئة `GITHUB_TOKEN`)
- `--dry-run` — معاينة الخطوات دون تنفيذ

راجع `dart run tools/fetch_core_local.dart --help` للخيارات الكاملة.

## 📄 الترخيص

ترخيص MIT. راجع [LICENSE](LICENSE) للتفاصيل.
