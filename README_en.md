<h4 align="right">
  <a href="README.md">简体中文</a> | <strong>English</strong> | <a href="README_ru.md">Русский</a> | <a href="README_fa.md">فارسی</a> | <a href="README_ja.md">日本語</a> | <a href="README_ko.md">한국어</a>
</h4>

<h1 align="center">⚡ Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

**Bettbox is a multi-platform network debugging and traffic splitting client based on an early version of FlClash, refactored and powered by the Mihomo (Clash Meta) core.**

Following the principle of "Better Experience", Bettbox inherits the excellent user interface of the original project while deeply optimizing numerous details and internal logic. It aims to be a Mihomo client that delivers a smooth frontend experience, silent and power-efficient background operation, and long-term stability.

**Supported Core Protocols**: Shadowsocks ( R / 2022 / ShadowTLS / Restls ), Trojan, VMess, VLESS ( XHTTP / Reality ), Hysteria ( v1 / v2 ), TUIC, WireGuard, Tailscale, OpenVPN, SSH, AnyTLS, Mieru, Snell ( v1-v5 ), Masque, TrustTunnel, Sudoku, Gost-relay, as well as standard HTTP/Socks5, etc.

Bettbox stands for: Better Experience, Out of the box.

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 
---
### ✈️ Telegram Community

</div>

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

---


* **All Desktop Platforms**: **Windows** (x64/arm64), **macOS** (Intel/Apple Silicon), **Linux** (x64/arm64)
* **Android Devices**: Android (ARMv8/ ARMv7/ x86_64/ Universal)
* **Android TV**: Fully supported, ARMv7 32-bit optional
* **HarmonyOS NEXT**: Please use in conjunction with [[ZhuoYiTong]](https://harmonyos.cool/android-app).

**Other Installation Methods:**<br>
**ArchLinux:** <code>yay -S bettbox-bin or paru -S bettbox-bin</code><br>
**AMD64=v1:** <code>yay -S bettbox-compatible-bin or paru -S bettbox-compatible-bin</code>

---
</div>

## 🚀 Core Features

* **Out of the box**: Stable permission handling and seamless TUN/VPN integration. Pre-configured with plenty of optimizations and details, ensuring a usable state right out of the box.
* **Refined UI**: Carefully polished interface and functional interactions. Smooth high-framerate frontend animations, low energy consumption on mobile devices, and minimal CPU footprint on desktops.
* **Security Guardian**: The core engine closely tracks the Mihomo mainline branch and actively adapts to the latest features, maintaining strict cross-platform permission controls and verifications.
* **Resilience**: Optimized stability under multi-platform extreme scenarios. Built-in dual error detection mechanism with YAML format validation and early pre-parsing.
* **Performance First**: Native support for multi-platform ARM64 architecture. Implements hardware grading and overall Flutter optimization, fully utilizing hardware performance.
* **Enhanced Tools**: First multi-platform seamless smart start/stop, Android sleep mode support, one-click QUIC disable, system tray menu enhancements, and more.
* **Visual Settings**: Offers comprehensive UI-based settings. Supports immediate effect of changes without the need for manual configuration file editing.
* **Dashboard Widgets**: Includes built-in widgets that allow you to intuitively monitor real-time network speeds and operational status directly from the home screen.
* **Personalization**: Supports multiple color themes, custom icons/titles, and even includes 10 beautiful dynamic network speed test animations.
* **Broad Compatibility**: Actively maintains "Compatible" builds tailored for legacy hardware and older operating systems to extend device lifecycles.
* **Zero Privacy Risk**: Open source, ad-free. Fully transparent CI/CD pipeline and open to public auditing, strictly prohibiting any background telemetry or data collection.
* **Community-Driven**: We carefully evaluate community feedback and prioritize high-quality issues, your voice won't be drowned out.

---

## ❓ FAQ

1. **Installation, Startup and Security:**
   - For Android devices, please check **if sufficient background permissions are granted and if it meets the minimum system requirements**: Android 8.0+
   - For older desktop devices, please check the system platform architecture **to see if you need to download a specific CPU grade Compatible version**
   - **Security: The Bettbox project is completely open source and transparent. The current codebase has passed security auditing by the Signpath Foundation.**

2. **Common Desktop Issues:**
   - Windows Administrator Privileges: Handled automatically during installation, **no manual authorization is required afterward**.
   - Unable to start TUN adapter: On macOS and Linux, **please ensure you enter the correct password to grant permissions**.
   - Other errors: Please provide Debug info, and **ensure no conflicting proxy software or services are running**.
   - If the issue persists, please open an Issue.

3. **macOS Installation Guide:**
   - After downloading the version matching your platform (Intel/Apple Silicon), double-click to open the Bettbox-macos-xx.dmg file.
   - Drag the Bettbox icon into the Applications folder to complete the installation.
   - **Bypass Gatekeeper security blocks for first launch** (since we currently do not purchase Apple developer certificates):
     - **Recommended**: Open the "Applications" folder, **right-click the Bettbox icon**, select **"Open"**, then click **"Open"** again in the confirmation dialog.
     - **Alternative**: If double-clicking is blocked, go to Mac "System Settings" -> "Privacy & Security", find Bettbox and click **"Open Anyway"**.
   - The first time you enable TUN mode, the system will prompt you for password authentication. Please enter your Mac user password to allow Bettbox to configure the network.
   - **If it says "is damaged and can't be opened, you should move it to the Trash":**
     - This is a false positive of macOS Gatekeeper for unsigned software. Open Terminal and run the following command to remove the quarantine flag:
       ```bash
       xattr -d com.apple.quarantine /Applications/Bettbox.app
       ```

4. **Unable to import subscription links:**
   - **Please make sure to try resetting the link first** to ensure it's active before importing.
   - **Ensure that the imported link is in Clash (Mihomo) format.**
   - If the issue persists, please open an Issue.

5. **To be continued...**

---

## 💻 Development

### Reference Environment

|     | Version | Notes              |
|-----|---------|--------------------|
|Flutter|3.44.6|≥3.44|
|Go|1.24.x|1.20.x for compatible build|
|Java|temurin-17.x||
|Android SDK|36.1||
|Android NDK|27.0.12077973<br>28.2.13676358|core<br>app|
|Rust|Latest stable||

### Build & Package

#### Windows

* Minimum requirement: Windows 10 1809
* Toolchain: Flutter, Golang, Cargo, Visual Studio ≥ 2022
* exe packaging: Inno Setup

```powershell
# Build and package
flutter pub get
dart run build_runner build -d
dart .\setup.dart windows
```

#### Linux

* Toolchain: Flutter, Golang, Clang, CMake, Ninja, pkg-config
* Dependencies: libcurl4, gtk3, libayatana-appindicator, libkeybinder3, libfuse2 (for AppImage)
* DEB packaging: dpkg-deb
* RPM packaging: rpm, patchelf
* AppImage packaging: appimagetool, locate, libfuse2

```bash
# Install dependencies
## Ubuntu 24.04 example, install as needed
sudo apt install build-essential clang cmake ninja-build
sudo apt install libcurl4-openssl-dev libgtk-3-dev libayatana-appindicator3-dev libkeybinder-3.0-dev libfuse2
sudo apt install dpkg-deb rpm patchelf locate
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool
sudo mv appimagetool /usr/local/bin/

# Build and package
## Set --targets as needed, separated by ","
flutter pub get
dart run build_runner build -d
dart setup.dart linux --targets=deb,rpm,appimage
# Build only (no packaging)
dart setup.dart linux --build-only
```

#### macOS

* Toolchain: Flutter, Golang, Xcode command-line tools, CocoaPods
* Packaging: appdmg

```zsh
# Install dependencies
npm install -g appdmg
# Build and package
flutter pub get
dart run build_runner build -d
dart setup.dart macos
```

#### Android

* Toolchain: Flutter, Golang, CMake, Android SDK, Android SDK Build-Tools, Android SDK Command-line Tools (optional: standalone sdkmanager), Android SDK Platform-Tools, Android NDK

1. Configure build environment

   * Android SDK, NDK and Tools

     * Configure using Android Studio

       See [Flutter official documentation](https://docs.flutter.dev/platform-integration/android/setup)

     * Install from command line (Linux example)

       ```bash
       # Set environment variables
       echo 'export ANDROID_HOME=$HOME/.local/opt/android-sdk' >> ~/.bashrc
       echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' >> ~/.bashrc
       source ~/.bashrc

       # Install SDK, NDK, Tools
       ## Using sdkmanager
       sudo apt install sdkmanager
       sdkmanager --install "build-tools;36.0.0" "cmdline-tools;latest" "platform-tools" "platforms;android-36.1" "ndk;27.0.12077973" "ndk;28.2.13676358"

       # Accept licenses
       flutter doctor --android-licenses
       ```

   * Configure Keystore

     1. Generate a new keystore or import an existing one to `./android/app/keystore.jks`
     2. (Without Android Studio) Create or open `./android/local.properties`, add the following:

        ```properties
        keyAlias=<key alias>
        storePassword=<keystore password>
        keyPassword=<key password>
        ```
   * Run `flutter doctor` to verify build environment

2. Build and package

   ```bash
   flutter pub get
   dart run build_runner build -d
   dart setup.dart android --arch=universal
   ```

#### Tips & Notices

1. The current version of flutter_distributor (v0.4.2) hardcodes the Inno Setup installation path (`C:\Program Files (x86)\Inno Setup 6`). Make sure it is installed to the default directory with administrator privileges
2. Use the `--compatible` flag to build for [older CPUs](https://go.dev/wiki/MinimumRequirements#amd64)
3. Run `dart setup.dart help <platform>` for more command-line options

### Debugging (VS Code)

Windows example:

1. Ensure core is pre-built
```powershell
dart .\setup.dart windows --out core --dev --ensure
```
2. Connect the target device and press F5 to start debugging

---

### ☕ Sponsorship

**If you find this project helpful, you can sponsor the development through the following methods:**

* TRON (TRC-20): <code>TCkTtZfF2WrciZLaJj3e1aqrh3zdTnCkDa</code>
* EVM Compatible: <code>0xF8B1B39431013359D83F38a4e403087624618E67</code>
* Solana: <code>C2YQPcKR2YmrPtBvkE13wckjgescUfMA5HzUioR4rQUd</code>
* Bitcoin: <code>bc1qu950cl6035qvllmzk6cfw3l30j2lg3cq9n6g6h</code>

---

## ❤️ Acknowledgements

**[FlClash GUI](https://github.com/chen08209/FlClash)** - **[Mihomo Core](https://github.com/MetaCubeX/mihomo)**

* The Windows digital signature for the Bettbox project is provided by **[SignPath](https://signpath.io)**, and the code has passed security reviews.
* Heartfelt thanks to the **SignPath Foundation** for their generous support of the open-source community.

Other open-source project references (listed in chronological order):

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 License

Licensed under the GPL-3.0 License.
