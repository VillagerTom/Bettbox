<h4 align="right">
  <a href="README.md">简体中文</a> | <a href="README_en.md">English</a> | <a href="README_ru.md">Русский</a> | <a href="README_fa.md">فارسی</a> | <a href="README_ja.md">日本語</a> | <strong>한국어</strong>
</h4>

<h1 align="center">⚡ Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

**Bettbox는 Mihomo(Clash Meta) 커널을 사용하고 FlClash의 초기 버전을 기반으로 재구축된 멀티플랫폼 네트워크 디버깅 및 트래픽 분류 클라이언트입니다.**

"Better Experience (더 나은 경험)"의 원칙에 따라, Bettbox는 기존의 훌륭한 UI를 계승하면서 수많은 세부 로직과 실용적인 기능을 깊이 있게 최적화했습니다. 프론트엔드는 부드럽게 작동하고, 백그라운드는 전력 소비 없이 작동하며, 장기적으로 안정적으로 운영될 수 있는 Mihomo 클라이언트를 지향합니다.

**지원 프로토콜**：Shadowsocks ( R / 2022 / ShadowTLS / Restls )、Trojan、VMess、VLESS ( XHTTP / Reality )、Hysteria ( v1 / v2 )、TUIC、WireGuard、Tailscale、OpenVPN、SSH、AnyTLS、Mieru、Snell ( v1-v5 )、Masque、TrustTunnel、Sudoku、Gost-relay, HTTP/Socks5 등.

Bettbox의 의미：Better Experience, Out of the box (뛰어난 경험을, 설치하자마자 바로).

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 
---
### ✈️ Telegram 커뮤니티

</div>

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

---

## 🛠️ 설치 및 다운로드

플랫폼과 시스템에 맞는 최신 설치 패키지를 **[[Releases]](https://github.com/appshubcc/Bettbox/releases)** 페이지에서 다운로드하십시오.

* **모든 데스크톱 플랫폼**: **Windows** (x64/arm64), **macOS** (Intel/Apple Silicon), **Linux** (x64/arm64)
* **Android 기기**: Android (ARMv8/ ARMv7/ x86_64/ Universal)
* **Android TV**: 완전한 지원, ARMv7 32비트 버전 선택 가능
* **HarmonyOS NEXT**: [[卓易通]](https://harmonyos.cool/android-app) 프로그램과 함께 사용하십시오.

**기타 설치 방법:**<br>
**ArchLinux:** <code>yay -S bettbox-bin 또는 paru -S bettbox-bin</code><br>
**AMD64=v1:** <code>yay -S bettbox-compatible-bin 또는 paru -S bettbox-compatible-bin</code>

---
</div>

## 🚀 핵심 특징

* **간편한 사용 (Out of the box)**: 안정적인 권한 처리와 쾌적한 TUN/VPN 통합. 수많은 최적화와 상세 설정이 미세 조정되어 설치 즉시 바로 사용 가능합니다.
* **정밀하게 다듬어진 UI**: 세부적인 UI와 기능적 인터랙션을 꼼꼼하게 다듬었습니다. 프론트엔드의 부드러운 고프레임 레이트 애니메이션, 모바일에서의 낮은 전력 소비, 데스크톱에서의 최소 리소스 점유를 실현합니다.
* **보안 지킴이**: 커널은 Mihomo의 메인라인 브랜치를 긴밀히 추적하고 최신 기능에 적극적으로 대응하며, 멀티플랫폼에서 엄격한 권한 관리 및 검증을 유지합니다.
* **안정적인 예외 처리**: 다양한 플랫폼의 극한 시나리오에서 안정성을 최적화했습니다. YAML 형식 검증 및 조기 사전 파싱을 통합한 이중 오류 감지 메커니즘을 내장하고 있습니다.
* **성능 최우선**: 데스크톱의 네이티브 ARM64 아키텍처 지원. 하드웨어 세분화 및 Flutter 전체 최적화를 구현하여 하드웨어 성능을 온전히 발휘합니다.
* **향상된 도구**: 멀티플랫폼 최초의 매끄러운 스마트 시작/중지, Android 취침 모드 지원, 원클릭 QUIC 비활성화, 시스템 트레이 메뉴 확장 등을 지원합니다.
* **시각적인 설정**: 다양한 매개변수를 UI에서 시각적으로 조절할 수 있습니다. 설정 파일을 수동으로 복잡하게 편집할 필요 없이 즉시 변경 사항이 적용됩니다.
* **대시보드 위젯**: 홈 화면에서 실시간 네트워크 속도와 전체 시스템 상태를 한눈에 모니터링할 수 있는 멋진 위젯을 내장하고 있습니다.
* **개인화 설정**: 다양한 색상 테마, 커스텀 아이콘/제목을 지원하며, 10가지 아름다운 동적 속도 측정 애니메이션을 포함합니다.
* **장치 호환성**: 오래된 시스템 및 하드웨어를 위한 Compatible(호환) 버전을 지속적으로 유지 관리하여 장치 수명을 연장합니다.
* **개인정보 위험 제로**: 오픈소스, 광고 없음. 투명하게 공개된 CI/CD 파이프라인과 포괄적인 보안 감사를 수용하여 백그라운드에서의 무단 데이터 수집을 엄격히 금지합니다.
* **커뮤니티 중심**: 우리는 커뮤니티의 피드백을 신중하게 검토하고 고품질 Issue를 우선적으로 처리합니다. 여러분의 목소리가 무시되지 않습니다.

---

## ❓ 자주 묻는 질문

1.  **설치 후 실행이 되지 않는 경우:**
    - Android 기기의 경우, **충분한 백그라운드 권한이 부여되었는지, 그리고 최소 시스템 요구 사항을 충족하는지** 확인하십시오: Android 8.0+
    - 오래된 데스크톱 기기의 경우, 시스템 아키텍처에 따라 **특정 CPU 세대를 위한 Compatible(호환) 버전을 다운로드해야 하는지** 확인하십시오.
    - **보안에 대해: Bettbox 프로젝트는 완전히 오픈소스이며 투명하게 운영됩니다. 현재 코드는 이미 Signpath 재단의 보안 감사를 통과했습니다.**

2.  **데스크톱의 일반적인 문제:**
    - Windows 관리자 권한: 설치 시 자동으로 처리되므로, **이후 별도의 수동 권한 승인이 필요하지 않습니다**.
    - TUN 가상 네트워크 어댑터를 켤 수 없는 경우: macOS 및 Linux에서는 **권한을 부여하기 위해 올바른 사용자 암호를 입력했는지** 확인하십시오.
    - 기타 오류: 디버그 정보를 제공하고, **동일한 포트를 사용하는 다른 프록시 소프트웨어나 서비스가 실행 중이지 않은지** 확인하십시오.
    - 문제가 지속되면 Issue를 제출해 주시기 바랍니다.

3.  **macOS 설치 안내:**
    - 사용 중인 플랫폼(Intel/Apple Silicon)에 맞는 파일을 다운로드한 후, Bettbox-macos-xx.dmg 파일을 더블 클릭하여 엽니다.
    - Bettbox 아이콘을 Applications(응용 프로그램) 폴더로 드래그 앤 드롭하여 설치를 완료합니다.
    - **첫 실행 시 Gatekeeper 보안 차단 우회 방법** (현재 공식 Apple 개발자 인증서를 구매하지 않았기 때문):
      - **추천**: 응용 프로그램 폴더로 이동한 후 **Bettbox 아이콘을 마우스 오른쪽 버튼으로 클릭**하고 **"열기"**를 선택한 다음, 확인 창에서 다시 **"열기"**를 클릭합니다.
      - **대안**: 더블 클릭으로 실행할 수 없는 경우, Mac 시스템 설정 -> "개인정보 보호 및 보안"으로 이동하여 Bettbox를 찾고 **"확인 없이 열기"**를 클릭합니다.
    - 처음 TUN 모드를 활성화할 때 시스템 암호 입력을 요구하는 창이 뜹니다. Mac의 사용자 암호를 입력하여 Bettbox의 네트워크 구성을 허용해 주십시오.
    - **"손상되었기 때문에 열 수 없습니다. 휴지통으로 이동해야 합니다"라고 표시되는 경우:**
      - 이는 서명되지 않은 소프트웨어에 대한 macOS Gatekeeper의 오동작입니다. 터미널(Terminal)을 열고 다음 명령어를 실행하여 격리 속성을 제거해 주십시오:
        ```bash
        xattr -d com.apple.quarantine /Applications/Bettbox.app
        ```

4.  **구독 링크를 가져올 수 없는 경우:**
    - 가져오기 전에 **구독 링크가 활성화되어 있는지 먼저 확인**하여 링크가 정상인지 점검하십시오.
    - 가져오는 링크가 **Clash(Mihomo) 형식** 인지 확인하십시오.
    - 문제가 지속되면 Issue를 제출해 주시기 바랍니다.

5.  **계속해서 보완 및 추가 예정...**

---

## 💻 개발 및 빌드

### 참고 환경

|    |버전|비고|
|----|----|---|
|Flutter|3.44.6|≥3.44|
|Go|1.24.x|1.20.x for compatible build|
|Java|temurin-17.x||
|Android SDK|36.1||
|Android NDK|27.0.12077973<br>28.2.13676358|core<br>app|
|Rust|Latest stable||

### 빌드 및 패키징

#### Windows

* 최소 요구 사항: Windows 10 1809
* Toolchain: Flutter, Golang, Cargo, Visual Studio ≥ 2022
* exe 패키징: Inno Setup

```powershell
# 빌드 및 패키징
flutter pub get
dart run build_runner build -d
dart .\setup.dart windows
```

#### Linux

* Toolchain: Flutter, Golang, Clang, CMake, Ninja, pkg-config
* 의존 라이브러리: libcurl4, gtk3, libayatana-appindicator, libkeybinder3, libfuse2(for AppImage)
* DEB 패키징: dpkg-deb
* RPM 패키징: rpm, patchelf
* AppImage 패키징: appimagetool, locate, libfuse2

```bash
# 의존성 설치
## Ubuntu 24.04 기준, 필요에 따라 설치
sudo apt install build-essential clang cmake ninja-build
sudo apt install libcurl4-openssl-dev libgtk-3-dev lbayatana-appindicator3-dev libkeybinder-3.0-dev libfuse2
sudo apt install dpkg-deb rpm patchelf locate
wget https://github.com/Appimage/AppimageKit/releases/download/containuous/appimagetool-x86_64.AppImage
chmod +x appimagetool
sudo mv appimagetool /usr/local/bin/

# 빌드 및 패키징
## 필요에 따라 --targets 파라미터를 ","로 구분하여 입력
flutter pub get
dart run build_runner build -d
dart setup.dart linux --targets=deb,rpm,appimage
# 빌드만 수행
dart setup.dart linux --build-only
```

#### Mac OS

* Toolchain: Flutter, Golang, Xcode command-line tools, CocoaPods
* 패키징: appdmg

```zsh
# 의존성 설치
npm install appdmg
# 빌드 및 패키징
flutter pub get
dart run build_runner build -d
dart setup.dart macos
```

#### Android

* Toolchain: Flutter, Golang, CMake, Android SDK, Android SDK Build-Tools, Android SDK Command-line Tools(optional: independent sdkmanager), Android SDK Platform-Tools, Android NDK

1. 빌드 환경 구성

  * Android SDK, NDK and Tools

    * Android Studio로 구성

      [Flutter 공식 문서](https://docs.flutter.dev/platform-integration/android/setup) 참조
      
    * 명령줄에서 설치 (Linux 플랫폼 예시)

      ```bash
      # 환경 변수 설정
      echo 'export ANDROID_HOME=$HOME/.local/opt/android-sdk' >> ~/.bashrc
      echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' >> ~/.bashrc
      sourec ~/.bashrc

      # SDK, NDK, Tools 설치
      ## sdkmanager.py 사용
      sudo apt install sdkmanager
      sdkmanager --install "build-tools;36.0.0" "cmdline-tools;latest" "platform-tools" "platforms;android-36.1" "ndk;27.0.12077973" "ndk;28.2.13676358"

      # 라이선스 수락
      flutter doctor --android-lincenses
      ```
  
  * Keystore 구성

    1. 새 Keystore를 생성하거나 기존 Keystore를 `./android/app/keystore.jks`로 가져오기
    2. (Android Studio 없음) `./android/local.properties` 파일을 생성하거나 열고 다음 파라미터 추가

      ```properties
      keyAlias=<키 별칭>
      storePassword=<Keystore 암호>
      keyPassword=<키 암호>
      ```
  * `flutter doctor` 실행하여 빌드 환경 무결성 확인

2. 빌드 및 패키징

  ```bash
  flutter pub get
  dart run build-runner build -d
  dart setup.dart android --arch=universal
  ```

#### 팁 및 주의사항

1. 현재 버전의 flutter_distributor(v0.4.2)는 Inno Setup 설치 경로(`C:\Program Files (x86)\Inno Setup 6`)를 하드코딩하고 있으므로, 반드시 관리자 권한으로 기본 디렉터리에 설치되어 있는지 확인하십시오
2. `--compatible` 파라미터를 사용하여 [구형 CPU](https://go.dev/wiki/MinimumRequirements#amd64)용으로 빌드
3. `dart setup.dart help <platform>` 실행하여 더 많은 명령줄 옵션 확인

### 디버깅 (VS Code)

Windows 예시

1. core가 미리 빌드되어 있는지 확인
```powershell
dart .\setup.dart windows --out core --dev --ensure
```
2. 대상 기기에 연결하고 F5를 눌러 디버깅 시작

---

### ☕ 개발 후원

**이 프로젝트가 유용하다고 생각하신다면, 아래의 방법을 통해 개발을 후원하시거나 위의 추천 링크를 이용해 주십시오:**

* TRON (TRC-20): <code>TCkTtZfF2WrciZLaJj3e1aqrh3zdTnCkDa</code>
* EVM Compatible: <code>0xF8B1B39431013359D83F38a4e403087624618E67</code>
* Solana: <code>C2YQPcKR2YmrPtBvkE13wckjgescUfMA5HzUioR4rQUd</code>
* Bitcoin: <code>bc1qu950cl6035qvllmzk6cfw3l30j2lg3cq9n6g6h</code>

---

## ❤️ 감사의 글

**[FlClash GUI](https://github.com/chen08209/FlClash)** - **[Mihomo Core](https://github.com/MetaCubeX/mihomo)**

* Bettbox 프로젝트의 Windows 디지털 서명은 **[SignPath](https://signpath.io)**에서 제공하며, 코드는 보안 검토를 통과했습니다.
* 오픈 소스 커뮤니티에 대한 아낌없는 지원을 해주신 **SignPath 재단 (SignPath Foundation)**에 진심으로 감사드립니다.

기타 오픈소스 프로젝트 (시간 경과 순):

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 라이선스

GPL-3.0 라이선스 아래 오픈 소스로 공개되어 있습니다.
