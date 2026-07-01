<h4 align="right">
  <a href="README.md">简体中文</a> | <a href="README_en.md">English</a> | <a href="README_ru.md">Русский</a> | <strong>فارسی</strong> | <a href="README_ja.md">日本語</a> | <a href="README_ko.md">한국어</a>
</h4>

<h1 align="center">⚡ Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

**Bettbox یک کلاینت چندسکویی برای دیباگ شبکه و تقسیم ترافیک است که بر اساس نسخه اولیه FlClash بازنویسی شده و توسط هسته Mihomo (Clash Meta) قدرت گرفته است.**

با پایبندی به اصل "Better Experience (تجربه بهتر)"، Bettbox رابط کاربری عالی پروژه اصلی را به ارث می‌برد در حالی که جزئیات و منطق داخلی آن را عمیقاً بهینه‌سازی می‌کند. هدف آن ارائه یک کلاینت Mihomo با تجربه روان در فرانت‌اند، عملکرد بی‌صدا و کم‌مصرف در پس‌زمینه و پایداری طولانی‌مدت است.

**پروتکل‌های تحت پشتیبانی هسته**: Shadowsocks ( R / 2022 / ShadowTLS / Restls )، Trojan، VMess، VLESS ( XHTTP / Reality )، Hysteria ( v1 / v2 )، TUIC، WireGuard، Tailscale، OpenVPN، SSH، AnyTLS، Mieru، Snell ( v1-v5 )، Masque، TrustTunnel، Sudoku، Gost-relay و غیره.

Bettbox یعنی: Better Experience, Out of the box (تجربه برتر، آماده استفاده بلافاصله پس از نصب).

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 
---
### ✈️ جامعه تلگرام

</div>

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

---

## 🛠️ نصب و دانلود

لطفاً برای دانلود آخرین فایل نصب مناسب سیستم خود به صفحه **[[انتشارها (Releases)]](https://github.com/appshubcc/Bettbox/releases)** مراجعه کنید.

* **پلتفرم‌های دسکتاپ**: **Windows** (x64/arm64)، **macOS** (Intel/Apple Silicon)، **Linux** (x64/arm64)
* **اندروید**: Android (ARMv8/ ARMv7/ x86_64/ Universal)
* **تلویزیون اندروید (Android TV)**: پشتیبانی کامل، ARMv7 32-bit اختیاری
* **سیستم‌عامل HarmonyOS NEXT**: لطفاً همراه با برنامه [[ZhuoYiTong]](https://harmonyos.cool/android-app) استفاده کنید.

**سایر روش‌های نصب:**<br>
**آرچ لینوکس (ArchLinux):** <code>yay -S bettbox-bin یا paru -S bettbox-bin</code><br>
**AMD64=v1:** <code>yay -S bettbox-compatible-bin یا paru -S bettbox-compatible-bin</code>

---
</div>

## 🚀 ویژگی‌های اصلی

* **آماده استفاده بلافاصله پس از نصب**: مدیریت پایدار مجوزها و یکپارچه‌سازی بی‌نقص TUN/VPN. از پیش پیکربندی شده با بهینه‌سازی‌ها و جزئیات فراوان.
* **رابط کاربری ظریف**: صیقل دادن دقیق تمام جزئیات رابط کاربری و تعاملات. انیمیشن‌های روان با نرخ فریم بالا، مصرف انرژی کم در موبایل و حداقل استفاده از پردازنده در دسکتاپ.
* **نگهبان امنیت**: هسته برنامه به دقت شاخه اصلی Mihomo را دنبال کرده و فعالانه با آخرین ویژگی‌ها سازگار می‌شود. اعمال کنترل‌ها و تاییدهای سخت‌گیرانه در تمام پلتفرم‌ها.
* **پایداری بالا**: پایداری بهینه‌شده در سناریوهای بحرانی چندسکویی. مکانیسم تشخیص خطای دوگانه داخلی با اعتبارسنجی فرمت YAML و پیش‌پردازش زودهنگام.
* **اولویت با عملکرد**: پشتیبانی نیتیو از معماری ARM64 در دسکتاپ. بهینه‌سازی کامل فلاتر برای استفاده حداکثری از توان سخت‌افزار.
* **ابزارهای پیشرفته**: اولین شروع/توقف هوشمند و بدون وقفه چندسکویی، پشتیبانی از حالت خواب اندروید، غیرفعال‌سازی QUIC با یک کلیک، بهبودهای منوی تسک‌بار و غیره.
* **تنظیمات بصری**: ارائه یک رابط کاربری کامل برای تنظیم پارامترهای مختلف با قابلیت اعمال آنی تغییرات بدون نیاز به ویرایش دستی فایل‌های پیکربندی.
* **ویجت‌های داشبورد**: ویجت‌های داخلی شیک برای مانیتورینگ زنده سرعت شبکه و وضعیت کلی سیستم مستقیماً در صفحه اصلی.
* **شخصی‌سازی**: پشتیبانی از تم‌های رنگی متنوع، آیکون‌ها/عنوان‌های سفارشی و شامل ۱۰ انیمیشن تست سرعت پویا و زیبا.
* **سازگاری با دستگاه‌های قدیمی**: نگهداری مستمر از نسخه‌های سازگار (Compatible) برای سیستم‌عامل‌ها و سخت‌افزارهای قدیمی جهت افزایش طول عمر دستگاه‌ها.
* **حریم خصوصی کامل**: متن‌باز، بدون تبلیغات. فرآیند کاملاً شفاف CI/CD و باز برای ممیزی عمومی، با ممنوعیت کامل هرگونه جمع‌آوری داده یا تلمتری در پس‌زمینه.
* **جامعه‌محور**: ما بازخوردهای جامعه کاربری را با دقت ارزیابی کرده و به گزارش‌های باکیفیت اولویت می‌دهیم؛ صدای شما شنیده خواهد شد.

---

## ❓ سوالات متداول

1. **مشکلات نصب, راه‌اندازی و امنیت:**
   - برای دستگاه‌های اندرویدی، لطفاً بررسی کنید **که آیا مجوزهای کافی برای پس‌زمینه داده شده است و سیستم حداقل الزامات را داراست**: Android 8.0+
   - برای رایانه‌های قدیمی، بررسی کنید که آیا با توجه به معماری سیستم **نیاز به دانلود نسخه سازگار (Compatible) برای پردازنده خود دارید**.
   - **امنیت: پروژه Bettbox کاملاً متن‌باز و شفاف است. کد فعلی ممیزی امنیتی بنیاد Signpath را با موفقیت پشت سر گذاشته است.**

2. **مشکلات رایج دسکتاپ:**
   - دسترسی مدیریت (Administrator) در ویندوز: به صورت خودکار در هنگام نصب انجام می‌شود و **بعد از آن نیازی به مجوز دستی نیست**.
   - عدم امکان فعال‌سازی کارت شبکه مجازی TUN: در سیستم‌عامل‌های macOS و Linux **اطمینان حاصل کنید که رمز عبور صحیح را برای اعطای مجوز وارد کرده‌اید**.
   - سایر خطاها: لطفاً اطلاعات دیباگ را ارائه دهید و **مطمئن شوید هیچ نرم‌افزار یا سرویس پروکسی دیگری در حال اجرا نیست**.
   - در صورت تداوم مشکل، لطفاً یک ایشو (Issue) ثبت کنید.

3. **راهنمای نصب در macOS:**
   - پس از دانلود نسخه متناسب با پلتفرم خود (Intel/Apple Silicon)، روی فایل Bettbox-macos-xx.dmg دوبار کلیک کنید تا باز شود.
   - آیکون Bettbox را به پوشه Applications بکشید تا نصب کامل شود.
   - **میانبر زدن بلاک امنیتی Gatekeeper برای اولین اجرا** (زیرا در حال حاضر گواهی توسعه‌دهنده رسمی اپل را خریداری نکرده‌ایم):
     - **روش پیشنهادی**: به پوشه "Applications" بروید، **روی آیکون Bettbox راست‌کلیک کنید**، گزینه **"Open"** را انتخاب کرده و سپس در کادر تایید دوباره روی **"Open"** کلیک کنید.
     - **روش جایگزین**: اگر باز کردن با دوبار کلیک مسدود شد، به "System Settings" -> "Privacy & Security" بروید، Bettbox را پیدا کرده و روی **"Open Anyway"** کلیک کنید.
   - در اولین بار فعال‌سازی حالت TUN، سیستم از شما رمز عبور می‌خواهد. لطفاً رمز عبور کاربر مک خود را وارد کنید تا اجازه پیکربندی شبکه به Bettbox داده شود.
   - **اگر با خطای "damaged and can't be opened, you should move it to the Trash" مواجه شدید:**
     - این یک هشدار اشتباه Gatekeeper برای نرم‌افزارهای امضا نشده است. ترمینال را باز کرده و دستور زیر را اجرا کنید تا نشان قرنطینه پاک شود:
       ```bash
       xattr -d com.apple.quarantine /Applications/Bettbox.app
       ```

4. **عدم امکان وارد کردن لینک‌های اشتراک:**
   - **لطفاً ابتدا لینک را ریست کنید** تا مطمئن شوید قبل از درون‌ریزی فعال است.
   - **مطمئن شوید لینک وارد شده در فرمت Clash (Mihomo) باشد.**
   - در صورت تداوم مشکل, لطفاً یک ایشو (Issue) ثبت کنید.

5. **به زودی موارد بیشتری اضافه خواهد شد...**

---

## 💻 توسعه و ساخت

### محیط مرجع

|    |نسخه|توضیحات|
|----|----|---|
|Flutter|3.44.6|≥3.44|
|Go|1.24.x|1.20.x برای ساخت سازگار|
|Java|temurin-17.x||
|Android SDK|36.1||
|Android NDK|27.0.12077973<br>28.2.13676358|core<br>app|
|Rust|آخرین نسخه پایدار||

### ساخت و بسته‌بندی

#### Windows

* حداقل نیازمندی: Windows 10 1809
* Toolchain: Flutter, Golang, Cargo, Visual Studio ≥ 2022
* بسته‌بندی exe: Inno Setup

```powershell
# ساخت و بسته‌بندی
flutter pub get
dart run build_runner build -d
dart .\setup.dart windows
```

#### Linux

* Toolchain: Flutter, Golang, Clang, CMake, Ninja, pkg-config
* کتابخانه‌های وابسته: libcurl4, gtk3, libayatana-appindicator, libkeybinder3, libfuse2(برای AppImage)
* بسته‌بندی DEB: dpkg-deb
* بسته‌بندی RPM: rpm, patchelf
* بسته‌بندی AppImage: appimagetool, locate, libfuse2

```bash
# نصب وابستگی‌ها
## به عنوان مثال در Ubuntu 24.04، در صورت نیاز نصب کنید
sudo apt install build-essential clang cmake ninja-build
sudo apt install libcurl4-openssl-dev libgtk-3-dev lbayatana-appindicator3-dev libkeybinder-3.0-dev libfuse2
sudo apt install dpkg-deb rpm patchelf locate
wget https://github.com/Appimage/AppimageKit/releases/download/containuous/appimagetool-x86_64.AppImage
chmod +x appimagetool
sudo mv appimagetool /usr/local/bin/

# ساخت و بسته‌بندی
## پارامتر --targets را در صورت نیاز با جداکننده "," تنظیم کنید
flutter pub get
dart run build_runner build -d
dart setup.dart linux --targets=deb,rpm,appimage
# فقط ساخت
dart setup.dart linux --build-only
```

#### Mac OS

* Toolchain: Flutter, Golang, Xcode command-line tools, CocoaPods
* بسته‌بندی: appdmg

```zsh
# نصب وابستگی‌ها
npm install appdmg
# ساخت و بسته‌بندی
flutter pub get
dart run build_runner build -d
dart setup.dart macos
```

#### Android

* Toolchain: Flutter, Golang, CMake, Android SDK, Android SDK Build-Tools, Android SDK Command-line Tools(اختیاری: sdkmanager مستقل), Android SDK Platform-Tools, Android NDK

1. پیکربندی محیط ساخت

  * Android SDK, NDK and Tools

    * پیکربندی با Android Studio

       به [مستندات رسمی Flutter](https://docs.flutter.dev/platform-integration/android/setup) مراجعه کنید
      
    * نصب از خط فرمان (به عنوان مثال در لینوکس)

      ```bash
      # تنظیم متغیرهای محیطی
      echo 'export ANDROID_HOME=$HOME/.local/opt/android-sdk' >> ~/.bashrc
      echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' >> ~/.bashrc
      sourec ~/.bashrc

      # نصب SDK، NDK، Tools
      ## با استفاده از sdkmanager.py
      sudo apt install sdkmanager
      sdkmanager --install "build-tools;36.0.0" "cmdline-tools;latest" "platform-tools" "platforms;android-36.1" "ndk;27.0.12077973" "ndk;28.2.13676358"

      # پذیرش مجوزها
      flutter doctor --android-lincenses
      ```
  
  * پیکربندی Keystore

    1. یک Keystore جدید ایجاد کنید یا Keystore موجود را به `./android/app/keystore.jks` وارد کنید
    2. (بدون Android Studio) فایل `./android/local.properties` را ایجاد یا باز کنید و پارامترهای زیر را اضافه کنید

      ```properties
      keyAlias=<نام مستعار کلید>
      storePassword=<رمز Keystore>
      keyPassword=<رمز کلید>
      ```
  * برای بررسی کامل بودن محیط ساخت، `flutter doctor` را اجرا کنید

2. ساخت و بسته‌بندی

  ```bash
  flutter pub get
  dart run build-runner build -d
  dart setup.dart android --arch=universal
  ```

#### نکات و تذکرات

1. نسخه فعلی flutter_distributor (v0.4.2) مسیر نصب Inno Setup را به صورت سخت‌کد شده (`C:\Program Files (x86)\Inno Setup 6`) دارد، حتماً مطمئن شوید که با دسترسی مدیر در مسیر پیش‌فرض نصب شده است
2. برای ساخت برای [پردازنده‌های قدیمی](https://go.dev/wiki/MinimumRequirements#amd64) از پارامتر `--compatible` استفاده کنید
3. برای مشاهده گزینه‌های خط فرمان بیشتر، `dart setup.dart help <platform>` را اجرا کنید

### دیباگ (VS Code)

به عنوان مثال در ویندوز

1. مطمئن شوید core از قبل ساخته شده است
```powershell
dart .\setup.dart windows --out core --dev --ensure
```
2. دستگاه هدف را متصل کرده و F5 را برای شروع دیباگ فشار دهید

---

### ☕ حمایت مالی

**اگر این پروژه را مفید می‌دانید، می‌توانید از طریق روش‌های زیر از توسعه آن حمایت کنید:**

* TRON (TRC-20): <code>TCkTtZfF2WrciZLaJj3e1aqrh3zdTnCkDa</code>
* EVM Compatible: <code>0xF8B1B39431013359D83F38a4e403087624618E67</code>
* Solana: <code>C2YQPcKR2YmrPtBvkE13wckjgescUfMA5HzUioR4rQUd</code>
* Bitcoin: <code>bc1qu950cl6035qvllmzk6cfw3l30j2lg3cq9n6g6h</code>

---

## ❤️ تقدیر و تشکر

**[FlClash GUI](https://github.com/chen08209/FlClash)** - **[Mihomo Core](https://github.com/MetaCubeX/mihomo)**

* امضای دیجیتال ویندوز برای پروژه Bettbox توسط **[SignPath](https://signpath.io)** ارائه شده است و کد تحت بررسی امنیتی قرار گرفته است.
* تشکر صمیمانه از **بنیاد ساین‌پث (SignPath Foundation)** برای حمایت سخاوتمندانه آن‌ها از جامعه متن‌باز.

سایر پروژه‌های متن‌باز (به ترتیب زمانی):

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 لایسنس

تحت لایسنس GPL-3.0.
