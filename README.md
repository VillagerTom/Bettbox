<h4 align="right">
  <strong>简体中文</strong> | <a href="README_en.md">English</a> | <a href="README_ru.md">Русский</a> | <a href="README_fa.md">فارسی</a> | <a href="README_ja.md">日本語</a> | <a href="README_ko.md">한국어</a>
</h4>

<h1 align="center">⚡ Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

**Bettbox 是一款使用Mihomo(Clash Meta)内核、基于FlClash早期版本进行重构的多平台网络调试及分流客户端**

秉承“Better Experience更优体验”的原则，Bettbox在继承原版优秀界面的基础上，深度优化了诸多细节与实用功能/逻辑。设计目标: 前台流畅丝滑、后台省电无感，致力于成为体验更好、可长期稳定运行的 Mihomo 客户端

**内核当前支持协议**：Shadowsocks ( R / 2022 / ShadowTLS / Restls )、Trojan、VMess、VLESS ( XHTTP / Reality )、Hysteria ( v1 / v2 )、TUIC、WireGuard、Tailscale、OpenVPN、SSH、AnyTLS、Mieru、Snell ( v1-v5 )、Masque、TrustTunnel、Sudoku、Gost-relay 以及 HTTP/Socks5 等。

Bettbox意为: Better Experience, Out of the box，卓越体验，亦开箱可用

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 
---
### ✈️ Telegram 社区交流

</div>

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

---
###   🛩️ 推荐链接
### [良心云](https://xn--9kqz23b19z.com/#/register?code=VTnrQYAj)  〢  [一分机场](https://xn--4gqx1hgtfdmt.com/#/register?code=AuCiXprV)  〢  [赔钱机场](https://xn--mes358aby2apfg.com/register?code=z7TUZLmM&cover=sfw)

**简评** : ❚ 相对性价比不错，21元/1000GB/不限时套餐 值得推荐，群友反馈口碑尚可; 需要注意: 机场服务与Bettbox软件无直接关联，最终效果请自行判定

---

## 🛠️ 安装与下载

请前往 **[[Releases]](https://github.com/appshubcc/Bettbox/releases)** 页面下载最新适合您平台和系统的安装包


* **全平台桌面端**: **Windows** (x64/arm64), **macOS** (Intel/Apple Silicon), **Linux** (x64/arm64)
* **Android 端**: Android (ARMv8/ ARMv7/ x86_64/ Universal) 
* **Android TV**: 已完整适配,可选ARMv7 32位
* **鸿蒙 NEXT**: 请配合 [[卓易通]](https://harmonyos.cool/android-app) 使用

**其他安装方式:**<br>
**ArchLinux:** <code>yay -S bettbox-bin 或 paru -S bettbox-bin</code><br>
**AMD64=v1:** <code>yay -S bettbox-compatible-bin 或 paru -S bettbox-compatible-bin</code>

---
</div>

## 🚀 核心特性

* **开箱即用**：稳定的权限处理与舒适的 TUN/VPN 体验，大量预置优化与细节，开箱即达可用状态。
* **精雕细琢**：打磨每处 UI 与功能交互细节，前台高帧率动画流畅，移动端低能耗，桌面端低占用。
* **安全守护**：内核紧跟 Mihomo 主线分支且积极适配最新特性，多平台保持严格的权限控制与校验。
* **稳定容错**：优化多平台极端场景下的稳定性，内置YAML格式验证和提前预解析双重错误检测机制。
* **性能优先**：桌面端原生 ARM64 架构支持，提供硬件分级和 Flutter 整体优化, 充分发挥硬件性能。
* **增强工具**：首个多平台无感智能启停、Android端休眠支持、一键禁用QUIC、托盘菜单增强等等。
* **可视化设置**：提供丰富参数的可视化调节界面，支持改动即时生效，无需繁琐修改配置。
* **首页小组件**：内置多款精致 Widget 小组件，在首页直观掌控实时网速与全局运行状态。
* **个性化定制**：支持丰富色彩主题、自定义图标/标题等，甚至还包含 10 种精美测速动画。
* **设备兼容**：持续维护面向旧版系统及老旧硬件的 Compatible 兼容版本，延长设备使用周期。
* **零隐私风险**：开源、无广告，全透明的 CI/CD 流程且接受全方位审计，杜绝后台隐私收集。
* **社区导向**：我们会认真评估社区反馈，优先对待高质量的 Issue，你的声音不会无故被淹没。

---

##  常见问题

1.  **安装启动及安全问题**：
   - 安卓端设备，请检查**是否授予了充足的后台权限及满足最低系统要求**:Android 8.0+
   - 桌面端旧设备，请检查系统平台架构**是否需要下载特定CPU等级的Compatible版本**
   - **安全问题：Bettbox 项目完全开源透明，当前代码已通过 Signpath 基金会安全审计**

2.  **桌面端常见问题**：
   - Windows管理员权限：Bettbox在安装时已提前处理，**无需手动再次授权**
   - 无法开启TUN虚拟网卡：macOS和Linux**请确保输入正确密码给与权限授权**
   - 其他报错：请提供Debug信息，并**确保没有冲突的代理软件或服务正在运行**
   - 其他问题如持续存在，请提交ISSUE反馈

3.  **macOS安装教程**：
   - 根据所属平台(Intel/Apple Silicon)下载完成后，双击打开 Bettbox-macos-xx.dmg 文件
   - 将 Bettbox 图标拖拽至 Applications（应用程序）文件夹中即可完成安装
   - **首次运行避开系统安全拦截**（由于当前暂未购买 Apple 开发者证书）：
     - **推荐**：进入“应用程序”文件夹，**右键 Bettbox 图标**，选择 **“打开”**，在确认弹窗中再次点击 **“打开”** 即可
     - **备选**：如果直接双击被阻止，请前往 Mac 系统“设置” -> “隐私与安全性”，找到 Bettbox 并点击 **“仍要打开”**
   - 首次开启 TUN 模式时，系统会弹出密码授权窗口，请输入当前用户密码以允许 Bettbox 配置网络
   - **如果提示“已损坏，打不开，移到废纸篓”**：
     - 这是 macOS 针对未签名软件的安全机制误报。请打开终端（Terminal），运行以下命令以解除隔离：
       ```bash
       xattr -d com.apple.quarantine /Applications/Bettbox.app
       ```

4.  **无法导入订阅链接**：
   - **请务必先尝试重置链接**，确保链接正常后再导入
   - **确保导入的是Clash（Mihomo）格式**的订阅链接
   - 其他问题如持续存在，请提交ISSUE反馈

5.  **待持续完善补充..**

---

##  开发构建

### 参考环境

|    |版本|备注|
|----|----|---|
|Flutter|3.44.6|≥3.44|
|Go|1.24.x|1.20.x for compatible build|
|Java|temurin-17.x||
|Android SDK|36.1||
|Android NDK|27.0.12077973<br>28.2.13676358|core<br>app|
|Rust|Latest stable||

### 构建与打包

#### Windows

* 最低要求: Windows 10 1809
* Toolchain: Flutter, Golang, Cargo, Visual Studio ≥ 2022
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

### ☕ 赞助支持

**如果您觉得这个项目对您有所帮助，可以通过以下方式赞助开发或使用上方的推荐链接：**

* TRON (TRC-20)：   <code>TCkTtZfF2WrciZLaJj3e1aqrh3zdTnCkDa</code>
* EVM Compatible：  <code>0xF8B1B39431013359D83F38a4e403087624618E67</code>
* Solana：  <code>C2YQPcKR2YmrPtBvkE13wckjgescUfMA5HzUioR4rQUd</code>
* Bitcoin： <code>bc1qu950cl6035qvllmzk6cfw3l30j2lg3cq9n6g6h</code>

---

##  致谢

**[FlClash GUI](https://github.com/chen08209/FlClash)** - **[Mihomo Core](https://github.com/MetaCubeX/mihomo)**

* Bettbox项目的 Windows 数字签名由 **[SignPath](https://signpath.io)** 提供，代码已通过安全审查
* 衷心感谢 **SignPath 基金会 (SignPath Foundation)** 对开源社区的大力支持

其他开源项目参考(以时间排序)：

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 开源协议

GPL-3.0 license 开源协议