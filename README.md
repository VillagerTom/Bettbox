<h4 align="right">
  <strong>简体中文</strong> | <a href="README_en.md">English</a> | <a href="README_ru.md">Русский</a>
</h4>

<h1 align="center">⚡ Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

Bettbox 是一款使用Mihomo(Clash Meta)内核、基于FlClash早期版本进行重构的多平台代理客户端

秉承“Better Experience更优体验”的原则，Bettbox在继承原版优秀界面的基础上，深度优化了诸多细节与实用功能/逻辑。前台流畅丝滑、后台省电无感，致力于成为体验更好、可长期稳定运行的 Mihomo 客户端

**内核当前支持协议**：Shadowsocks ( R / 2022 )、Trojan、VMess、VLESS ( XHTTP / Reality )、Hysteria ( v1 / v2 )、TUIC、WireGuard、Tailscale、OpenVPN、SSH、AnyTLS、Mieru、Snell ( v1-v5 )、Masque、TrustTunnel、Sudoku、Gost-relay 以及 HTTP/Socks5 等。

Bettbox意为: Better Experience, Out of the box，卓越体验，亦开箱即用

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 

---

##  🛩️ 推荐链接
### 高性价比： [Nano](https://edu.360buyimg.men/auth/register?code=P6hOCEVw)  〢  [良心云](https://xn--9kqz23b19z.com/#/register?code=VTnrQYAj)  〢  [一分机场](https://xn--4gqx1hgtfdmt.com/#/register?code=AuCiXprV)

简评 : ❚ 高性价比机场，支持流媒体与AI解锁，群友反馈口碑尚可，Nano推荐10元/300GB/月，良心云和一分机场推荐21元/1000GB永久套餐; ❚ 注: 机场服务与Bettbox软件无直接关联，请自行判定

---


## 🛠️ 安装与下载

请前往 [Releases](https://github.com/appshubcc/Bettbox/releases) 页面下载最新适合您平台和系统的安装包

其他安装方式:</br>
ArchLinux: yay -S bettbox-bin 或 paru -S bettbox-bin

* **桌面端多平台**: Windows (x64/arm64), macOS (Intel/Apple Silicon), Linux (x64/arm64)
* **Windows7**: 请配合 [[VxKex]](https://github.com/i486/VxKex/releases) 使用
* **Android平台**: Android (ARMv8/ ARMv7/ x86_64/ Universal) 
* **Android TV**: 已适配,可选ARMv7 32位
* **鸿蒙NEXT**: 请配合 [[卓易通]](https://harmonyos.cool/android-app) 使用

---
### ✈️ Telegram 社区交流

</div>

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

---
</div>

## 🚀 核心特性

### 深度体验优化
* **开箱即用**：稳定权限的处理与舒适的TUN/VPN体验，预置优化参数而非默认示例，开箱即达可用状态。
* **精雕细琢**：打磨每一处 UI 与交互细节，后台稳定轻量化运行，移动端低能耗，桌面端低占用。

### 安全与稳定性
* **安全守护**：内核紧跟 Mihomo 主线且积极适配新特性，多平台保持严格的权限控制与校验。
* **韧性容错**：优化极端场景下的稳定性，内置配置错误优雅回退机制，确保服务连续可靠性。

### 自由可定制化
* **可视化设置**：提供丰富参数的可视化调节界面，支持改动即时生效，无需繁琐修改配置。
* **首页小组件**：内置多款精致 Widget 小组件，在首页直观掌控实时网速与全局运行状态。
* **个性化定制**：支持丰富色彩主题、自定义图标/标题等，甚至包含了 10 种精美测速动画。

### 多平台与性能优化
* **性能优先**：原生支持桌面端 ARM64 架构，提供CPU硬件分级及 Flutter整体通信/响应性能优化。
* **设备兼容**：持续维护面向旧版系统及老旧硬件的 Compatible 兼容版本，延长设备使用周期。
* **社区导向**：我们会认真评估社区反馈，优先对待高质量的 Issue，你的声音不会无故被淹没。

### 开源纯净透明
* **自动化构建**：基于 GitHub Actions 的全透明 CI/CD 流程，代码即产物，所见即所得。
* **零隐私风险**：完全免费、无广告，代码开源且接受全方位审计，杜绝任何后台隐私收集。

---

##  常见问题

1. 安装后无法启动？
   - 安卓端旧设备，请检查是否满足Bettbox的最低系统要求:Android 8.0+
   - 桌面端旧设备，请检查是否需要下载特定CPU等级的Compatible兼容版本
   - 其他问题如持续存在，请提交ISSUE反馈

2. 桌面端常见问题
   - Windows管理员权限：Bettbox在安装时已提前处理，无需手动再次授权
   - 无法开启TUN虚拟网卡：macOS和Linux请确保输入正确密码给与权限授权
   - 其他报错：请提供日志信息，并确保没有冲突的代理软件或服务正在运行
   - 其他问题如持续存在，请提交ISSUE反馈

3. 无法导入订阅链接
   - 请务必先尝试重置链接，确保链接正常后再导入
   - 确保导入的是Clash（Mihomo）格式的订阅链接
   - 其他问题如持续存在，请提交ISSUE反馈

4. 待持续完善补充..

---

##  开发构建

### 参考环境

|    |版本|备注|
|----|----|---|
|Flutter|3.44.2|>=3.44|
|Go|1.24.x|1.20.x for compatible build|
|Java|temurin-17.x||
|Android SDK|36.1||
|Android NDK|27.0.12077973<br>28.2.13676358|core<br>app|
|Rust|Latest stable||

### 构建与打包

#### Windows

* Toolchain: Flutter, Golang, Cargo, Visual Studio >= 2022
* exe 打包: Inno Setup
 
```powershell
# 构建并打包
flutter pub get
dart run build_runner build -d
dart .\setup.dart windows
```

#### Linux

* Toolchain: Flutter, Golang, Clang, CMake, Ninja, pkg-config
* 依赖库: libcurl4, gtk3, libayatana-appindicator, libkeybinder3, libfuse2(for AppImage)
* DEB 打包: dpkg-deb
* RPM 打包: rpm, patchelf
* AppImage 打包: appimagetool, locate, libfuse2

```bash
# 安装依赖
## 以 Ubuntu 24.04 为例, 按需安装
sudo apt install build-essential clang cmake ninja-build
sudo apt install libcurl4-openssl-dev libgtk-3-dev lbayatana-appindicator3-dev libkeybinder-3.0-dev libfuse2
sudo apt install dpkg-deb rpm patchelf locate
wget https://github.com/Appimage/AppimageKit/releases/download/containuous/appimagetool-x86_64.AppImage
chmod +x appimagetool
sudo mv appimagetool /usr/local/bin/

# 构建并打包
## 按需填写 --targets 参数，使用 "," 分隔
flutter pub get
dart run build_runner build -d
dart setup.dart linux --targets=deb,rpm,appimage
# 仅构建
dart setup.dart linux --build-only
```

#### Mac OS

* Toolchain: Flutter, Golang, Xcode command-line tools, CocoaPods
* 打包: appdmg

```zsh
# 安装依赖
npm install appdmg
# 构建并打包
flutter pub get
dart run build_runner build -d
dart setup.dart macos
```

#### Android

* Toolchain: Flutter, Golang, CMake, Android SDK, Android SDK Build-Tools, Android SDK Command-line Tools(optional: independent sdkmanager), Android SDK Platform-Tools, Android NDK

1. 配置构建环境

  * Android SDK, NDK and Tools

    * 使用 Android Studio 配置

      参见 [Flutter 官方文档](https://docs.flutter.dev/platform-integration/android/setup)
      
    * 从命令行安装 (以 Linux 平台为例)

      ```bash
      # 配置环境变量
      echo 'export ANDROID_HOME=$HOME/.local/opt/android-sdk' >> ~/.bashrc
      echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' >> ~/.bashrc
      sourec ~/.bashrc

      # 安装 SDK, NDK, Tools
      ## 使用 sdkmanager.py
      sudo apt install sdkmanager
      sdkmanager --install "build-tools;36.0.0" "cmdline-tools;latest" "platform-tools" "platforms;android-36.1" "ndk;27.0.12077973" "ndk;28.2.13676358"

      # 接受许可证
      flutter doctor --android-lincenses
      ```
  
  * 配置 Keystore

    1. 生成新的 Keystore 或将已有 Keystore 导入至 `./android/app/keystore.jks`
    2. (无 Android Studio) 新建或打开 `./android/local.properties`, 添加以下参数

      ```properties
      keyAlias=<密钥别名>
      storePassword=<Keystore密码>
      keyPassword=<密钥密码>
      ```
  * 运行 `flutter doctor` 检查构建环境完整性

2. 构建并打包

  ```bash
  flutter pub get
  dart run build-runner build -d
  dart setup.dart android --arch=universal
  ```

#### Tips & Notice

1. 当前版本 flutter_distributor (v0.4.2) 硬编码了 Inno Setup 的安装路径 (`C:\Program Files (x86)\Inno Setup 6`), 务必以管理员权限安装至默认目录
2. 使用 `--compatible` 参数为[旧 CPU](https://go.dev/wiki/MinimumRequirements#amd64) 构建
3. 运行 `dart setup.dart help <platform>` 查看更多命令行选项

### 调试 (VS Code)

以 Windows 为例

1. 确保 core 已预先构建
```powershell
dart .\setup.dart windows --out core --dev --ensure
```
2. 连接目标设备，按 F5 开始调试

---

##  致谢

Bettbox 的诞生依赖以下根基项目：

* [FlClash](https://github.com/chen08209/FlClash) - 来自陈师傅的优秀开源GUI
* [Mihomo](https://github.com/MetaCubeX/mihomo) - 强大/灵活/稳定的代理内核

开发构建过程中还额外从以下开源项目获取过灵感(以参考顺序排名)：

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 开源协议

GPL-3.0 license 开源协议