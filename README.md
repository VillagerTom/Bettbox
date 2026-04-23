<h1 align="center"><img src="assets/images/icon.png" width="28" height="28" alt="icon"> Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

Bettbox 是一款使用Mihomo(Clash Meta)内核、基于FlClash早期版本进行重构的多平台代理客户端

秉承“Better Experience更优体验”的原则，Bettbox在继承原版优秀界面的基础上，深度优化了诸多细节与实用功能/逻辑。前台流畅丝滑、后台省电无感，致力于成为体验更好且可长期稳定运行的 Mihomo 客户端

Bettbox意为: Better Experience, Out of the box，卓越体验，亦可开箱即用

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 

---

## 💬 社区交流

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

</div>

---

## 🚀 核心特性

###  深度体验优化
* **开箱即用**：自动化的权限处理与舒适稳定的TUN&VPN体验，预置更加适合中国大陆用户的内核配置，减少繁琐的手动调试/配置多为可选项
* **精雕细琢**：重新审视打磨每一处功能细节，稳定无感的轻量模式，移动端更加省电、桌面端更低占用、旨在提供更好的Mihomo客户端体验

###  安全与稳定性
* **安全校验**：遵循Mihomo官方安全建议/内核升级紧跟主线版本，桌面端拥有严格的安全校验以及权限控制，有效防范潜在的TOCTOU或非法访问，同时针对常见配置错误增加了优雅的回退机制
* **高稳定性**：通过了作者自身和群友长期以来高强度的压力测试与后台使用测试，优化了多处极端场景下的使用稳定性问题

###  自由可定制化
* **可视化管理**：更加全面且易用的功能配置界面，支持更多参数的可视化操作调整和实时生效
* **实用小组件**：提供多种美观实用风格的 Widgets，在首页可以掌控全局流量和当前运行状态
* **个性化定制**：丰富的预置色彩主题、自定义图标/首页标题，多个界面布局调整，甚至连Urltest都有10种精美动画可供选择，每个人都可以拥有自己独一无二的Bettbox

###  多个平台支持
* **性能优先级**：支持主流架构，为现代设备额外优化的CPU性能(例如桌面端分级和Android 16K对齐)，针对多平台桌面端 ARM64 设备同样提供了原生适配
* **社区包容性**：我们倾听社区用户的想法并且会认真评估，你的声音不会无故被淹没和被无视(认真的ISSUE会被优先对待)
* **旧设备关怀**：尽力而为提供针对旧版本系统和硬件的兼容性版本，确保长周期的使用寿命

###  开源纯净透明
* **全自动 CI/CD**：基于 GitHub Actions 的透明构建流程，代码即产物，所见即所得
* **纯净无广告**：免费，且完全开源，代码接受全方位审计，无需担心额外的隐私问题

---

## 🛠️ 安装与下载

请前往 [Releases](https://github.com/appshubcc/Bettbox/releases) 页面下载最新适合您平台和系统的安装包

* **桌面端**: Windows (x64/arm64), macOS (Intel/Apple Silicon), Linux (x64/arm64)
* **安卓端**: Android (ARMv8/ ARMv7/ x86_64/ Universal) 
* **Android TV**: 已支持,可选ARMv7 32位
* **Windows7**: 请配合 [[VxKex]](https://github.com/i486/VxKex/releases) 使用
* **鸿蒙NEXT**: 请配合 [[卓易通]](https://harmonyos.cool/android-app) 使用

---

## 🏗️ 从源码构建

### 开发环境

|   |版本|备注|
|---|---|---|
|Flutter|3.35.7||
|Go|1.24.x|1.20.x for old CPUs|
|Java|temurin-17.x||
|Android SDK|36||
|Android NDK|28.2.13676358||
|Rust|Latest stable|For Windows helper service|

### Windows

* Toolchain: Flutter, Golang, Cargo(for helper service), Visual C++ Build Tools
* 打包: Inno Setup

1. 克隆本仓库

  ```powershell
  git clone https://github.com/appshubcc/Bettbox.git
  cd Bettbox
  ```

2. 配置开发环境

  * Flutter

    * 从 git 仓库安装

      ```powershell
      $installPath = "C:\tools" # 根据你的喜好替换
      cd $installPath
      git clone -b 3.35.7 https:github.com/flutter/flutter.git
      $newPath = "$env:Path;$installPath\flutter\bin"
      [Environment]::SetEnvironmentVariable("Path", "$newPath", "User")
      cd -
      ```
    * 使用 [FVM](https://fvm.app/documentation/getting-started/installation) 或 [mise](https://mise.jdx.dev/installing-mise.html) 安装
      ```powershell
      # FVM
      fvm use 3.35.7
      # mise
      mise use flutter@3.35.7
      ```
  * Golang
    * 从[官网](https://go.dev/dl/)下载
    
    * 使用 mise 安装

      ```powershell
      mise use go@1.20 # For compatibility for old CPUs
      ```
  * Rust
    * 使用 winget 安装

      ```powershell
      winget install Rustlang.Rustup
      ```
3. 配置构建环境
  * Visual C++ Build Tools

    下载 Visual Studio 或 [Visual Studio 生成工具](https://visualstudio.microsoft.com/visual-cpp-build-tools/)安装器，勾选“使用 C++ 的桌面开发”并安装

  * Inno Setup

    ```powershell
    winget install JRSoftware.InnoSetup
    ```

  * 运行 `flutter doctor` 检查构建环境完整性

4. 构建并打包 [^1] [^2]

  ```powershell
  flutter pub get
  dart run build_runner build -d
  dart setup.dart windows --arch=amd64 --compatible
  ```

### Linux

* Toolchain: Flutter, Golang, Clang, Cmake, Ninja, pkg-config
* 依赖库: libcurl4, gtk3, libayatana-appindicator, libkeybinder3, libfuse2(for appimagetool)
* 打包: dpkg-deb, rpm, appimagetool, patchelf(for rpm), locate(for appimagetool)

1. 克隆本仓库

  ```bash
  git clone https://github.com/appshubcc/Bettbox.git
  cd Bettbox
  ```
2. 配置开发环境

  * Flutter 
    * 使用 [FVM](https://fvm.app/documentation/getting-started/installation) 安装

      ```bash
      fvm use 3.35.7
      ```
  
  * Golang
    * 使用包管理器安装

      ```bash
      sudo apt install golang-go
      ```

    * 使用 [mise](https://mise.jdx.dev/installing-mise.html) 安装

      ```bash
      mise use go@1.20 # For compatibility for old CPUS
      ```

3. 安装构建依赖

  ```bash
  # 按需安装
  sudo apt install build-essential clang cmake ninja-build
  sudo apt install libcurl4-openssl-dev libgtk-3-dev lbayatana-appindicator3-dev libkeybinder-3.0-dev libfuse2
  sudo apt install dpkg-deb rpm patchelf locate
  wget https://github.com/Appimage/AppimageKit/releases/download/containuous/appimagetool-x86_64.AppImage
  chmod +x appimagetool
  sudo mv appimagetool /usr/local/bin/
  ```

4. 构建并打包 [^1] [^2]
  
  ```bash
  flutter pub get
  dart run build_runner build -d 
  # 按需填写 "--targets" 参数，使用 "," 分隔
  dart setup.dart linux --arch=amd64 --targets=deb,rpm,appimage --compatible
  ```

### Mac OS

* Toolchain: Flutter, Golang, Xcode command-line tools, CocoaPods
* 打包: appdmg

1. 克隆本仓库

  ```zsh
  git clone https://github.com/appshubcc/Bettbox.git
  cd Bettbox
  ```
2. 配置开发环境

  * Flutter
    * 使用 [FVM](https://fvm.app/documentation/getting-started/installation) 安装

      ```zsh
      fvm use 3.35.7
      ```

  * Golang

    * 使用包管理器安装

      ```zsh
      brew install go
      ```
    * 使用 [mise](https://mise.jdx.dev/installing-mise.html) 安装

      ```zsh
      mise use go@1.20 # For compatibility for old CPUS
      ```
  * Xcode, CocoaPods

      参见 [Flutter 官方文档](https://docs.flutter.dev/platform-integration/macos/setup) 

  * appdmg

    ```zsh
    npm install appdmg
    ```

3. 构建并打包 [^1] [^2]

  ```zsh
  flutter pub get
  dart run build_runner build -d
  dart setup.dart macos --arch=arm64
  ```

### Android

* Toolchain: Flutter, Golang, CMake, Android SDK, Android SDK Build-Tools, Android SDK Command-line Tools(optional: independent sdkmanager), Android SDK Platform-Tools

1. 配置编程语言

  * Flutter, Golang

    参见上文

  * Java

    * 使用 [mise](https://mise.jdx.dev/installing-mise.html) 安装

      ```bash
      mise use java@temurin-17
      ```
    
    * 在 Android Studio 中配置
      
2. 配置构建环境

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
      sdkmanager --install "build-tools;36.0.0" "cmdline-tools;latest" "platform-tools" "platforms;android-36.1" "ndk;28.2.13676358"

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

3. 构建并打包 [^2]

  ```bash
  flutter pub get
  dart run build-runner build -d
  dart setup.dart android --arch=universal
  ```

[^1]: 使用 `--compatible` 参数为[旧 CPU](https://go.dev/wiki/MinimumRequirements#amd64) 构建

[^2]: 运行 `dart setup.dart help <platform>` 查看更多选项

---

## 💡 常见问题

1. 安装后无法启动？
   - 安卓端旧设备，请检查是否支持Bettbox的最低系统要求:Android 8.0+
   - 桌面端旧设备，请检查是否需要下载特定CPU等级的Compatible兼容版本
   - 其他问题如持续存在，请提交ISSUE反馈

2. Windows常见问题
   - 管理员权限：Bettbox在安装时已提前处理，无需手动再次授权
   - 无法开启虚拟网卡：请确保没有冲突的代理软件或服务正在运行
   - 无法同时开启系统代理和虚拟网卡：预期行为（如果明确自己的需求，则可以通过系统托盘区同时开启）
   - 其他问题如持续存在，请提交ISSUE反馈

3. 无法导入订阅链接
   - 请务必先尝试重置链接，确保链接正常后再导入
   - 确保导入的是Clash（Mihomo）格式的订阅链接
   - 其他问题如持续存在，请提交ISSUE反馈

4. 待持续完善和补充..

---

## ☕ 赞助链接

* **暂无**:  所有功能均免费无广告，您可以点击右上角的⭐Star，让开发者获得认同感也是一种支持方式

---

## 🤝 致谢

Bettbox 的诞生依赖以下根基项目：

* [FlClash](https://github.com/chen08209/FlClash) - 来自陈师傅的优秀开源项目
* [Mihomo](https://github.com/MetaCubeX/mihomo) - 强大灵活稳定的代理内核

开发构建过程中还额外从以下开源项目获取过灵感(以参考顺序排名)：

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 开源协议

延续原项目 [GPL-3.0 license](LICENSE) 开源协议
