<h4 align="right">
  <a href="README.md">简体中文</a> | <a href="README_en.md">English</a> | <strong>Русский</strong> | <a href="README_fa.md">فارسی</a> | <a href="README_ja.md">日本語</a> | <a href="README_ko.md">한국어</a>
</h4>

<h1 align="center">⚡ Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

**Bettbox — это мультиплатформенный клиент для сетевой отладки и маршрутизации трафика, основанный на ранней версии FlClash, переработанный и работающий на ядре Mihomo (Clash Meta).**

Следуя принципу «Better Experience» (Лучший опыт), Bettbox наследует отличный пользовательский интерфейс оригинального проекта, при этом глубоко оптимизируя множество деталей и внутреннюю логику. Наша цель — создать клиент Mihomo, который обеспечивает плавную работу интерфейса, бесшумную и энергоэффективную работу в фоновом режиме, а также долгосрочную стабильность.

**Поддерживаемые базовые протоколы**: Shadowsocks ( R / 2022 / ShadowTLS / Restls ), Trojan, VMess, VLESS ( XHTTP / Reality ), Hysteria ( v1 / v2 ), TUIC, WireGuard, Tailscale, OpenVPN, SSH, AnyTLS, Mieru, Snell ( v1-v5 ), Masque, TrustTunnel, Sudoku, Gost-relay, а также стандартные HTTP/Socks5 и др.

Название Bettbox означает: **Better Experience, Out of the box** (Лучший опыт прямо из коробки).

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 
---
### ✈️ Сообщество в Telegram

</div>

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

---


* **Все настольные платформы**: **Windows** (x64/arm64), **macOS** (Intel/Apple Silicon), **Linux** (x64/arm64)
* **Android**: Android (ARMv8/ ARMv7/ x86_64/ Universal)
* **Android TV**: Полностью поддерживается, ARMv7 32-bit опционально.
* **HarmonyOS NEXT**: Пожалуйста, используйте совместно с [[ZhuoYiTong]](https://harmonyos.cool/android-app).

**Другие способы установки:**<br>
**ArchLinux:** <code>yay -S bettbox-bin или paru -S bettbox-bin</code><br>
**AMD64=v1:** <code>yay -S bettbox-compatible-bin или paru -S bettbox-compatible-bin</code>

---
</div>

## 🚀 Основные особенности

* **Готово к использованию**: Стабильная обработка разрешений и бесшовная интеграция TUN/VPN. Предустановлено множество оптимизаций и деталей, обеспечивая рабочее состояние прямо из коробки.
* **Продуманный UI**: Тщательно проработанный интерфейс и функциональные взаимодействия. Плавные высококадровые анимации интерфейса, низкое энергопотребление на мобильных устройствах и минимальная нагрузка на CPU на ПК.
* **Защита безопасности**: Ядро тщательно следует основной ветке Mihomo и активно адаптируется к новейшим функциям, поддерживая строгий кроссплатформенный контроль разрешений и проверки.
* **Отказоустойчивость**: Оптимизированная стабильность в экстремальных многоплатформенных сценариях. Встроенный двойной механизм обнаружения ошибок с валидацией формата YAML и ранним предварительным парсингом.
* **Производительность**: Встроенная поддержка кроссплатформенной архитектуры ARM64. Реализует аппаратное профилирование и общую оптимизацию Flutter, полностью используя возможности оборудования.
* **Дополнительные инструменты**: Первая в мире кроссплатформенная система бесшовного умного запуска/остановки, поддержка спящего режима Android, отключение QUIC в один клик, расширенное меню системного трея и т.д.
* **Визуальные настройки**: Предлагает комплексные настройки через пользовательский интерфейс. Поддерживает немедленное применение изменений без необходимости ручного редактирования конфигурационных файлов.
* **Виджеты на главном экране**: Включает встроенные виджеты, которые позволяют интуитивно контролировать скорость сети в реальном времени и рабочее состояние прямо с главного экрана.
* **Персонализация**: Поддерживает несколько цветовых тем, пользовательские иконки/заголовки, а также включает 10 красивых динамических анимаций тестирования скорости сети.
* **Широкая совместимость**: Активно поддерживает сборки «Compatible», адаптированные для старого оборудования и старых операционных систем, чтобы продлить жизненный цикл устройств.
* **Нулевой риск для приватности**: Открытый исходный код, без рекламы. Полностью прозрачный CI/CD процесс, открыт для публичного аудита, строго запрещен любой сбор данных в фоновом режиме.
* **Ориентация на сообщество**: Мы внимательно оцениваем отзывы сообщества и отдаем приоритет качественным Issue, ваш голос не останется незамеченным.

---

## ❓ FAQ (Часто задаваемые вопросы)

1. **Проблемы с установкой, запуском и безопасностью:**
   - Для устройств Android проверьте, **предоставлены ли достаточные фоновые разрешения и соответствует ли устройство минимальным системным требованиям**: Android 8.0+
   - Для старых ПК проверьте архитектуру системы, **требуется ли скачать специфическую сборку CPU класса Compatible**
   - **Безопасность: Проект Bettbox полностью с открытым исходным кодом и прозрачен, текущий код прошел проверку безопасности фонда Signpath.**

2. **Частые проблемы на ПК:**
   - Права администратора Windows: Обрабатываются автоматически при установке, **ручная авторизация больше не требуется**.
   - Не удается включить виртуальный адаптер TUN: На macOS и Linux **убедитесь, что вы ввели правильный пароль для предоставления прав**.
   - Другие ошибки: Пожалуйста, предоставьте Debug информацию и **убедитесь, что нет конфликтующих прокси-приложений или сервисов**.
   - Если проблема не решена, пожалуйста, создайте Issue.

3. **Инструкция по установке на macOS:**
   - После загрузки версии для вашей платформы (Intel/Apple Silicon) дважды щелкните, чтобы открыть файл Bettbox-macos-xx.dmg.
   - Перетащите значок Bettbox в папку Applications (Программы), чтобы завершить установку.
   - **Обход блокировок Gatekeeper при первом запуске** (так как мы пока не приобретали сертификат разработчика Apple):
     - **Рекомендуемый**: откройте папку «Программы», **нажмите правой кнопкой мыши по значку Bettbox**, выберите **«Открыть»**, а затем снова нажмите **«Открыть»** в диалоговом окне подтверждения.
     - **Альтернативный**: если двойной щелчок заблокирован, перейдите в «Системные настройки» -> «Конфиденциальность и безопасность», найдите Bettbox и нажмите **«Подтвердить вход»** (или «Разрешить в любом случае»).
   - При первом включении режима TUN система запросит аутентификацию пароля. Введите пароль текущего пользователя Mac, чтобы разрешить Bettbox настроить сеть.
   - **Если появляется сообщение «Приложение повреждено и его нельзя открыть. Вам следует переместить его в Корзину»:**
     - Это ложное срабатывание Gatekeeper macOS для неподписанного софта. Откройте Терминал и выполните следующую команду для снятия флага карантина:
       ```bash
       xattr -d com.apple.quarantine /Applications/Bettbox.app
       ```

4. **Не удается импортировать ссылку на подписку:**
   - **Обязательно сначала попробуйте сбросить ссылку**, чтобы убедиться, что она активна перед импортом.
   - **Убедитесь, что импортируемая ссылка имеет формат Clash (Mihomo).**
   - Если проблема не решена, пожалуйста, создайте Issue.

5. **Продолжение следует...**

---

## 💻 Разработка и сборка

### Эталонная среда

|    |Версия|Примечания|
|----|----|---|
|Flutter|3.44.6|≥3.44|
|Go|1.24.x|1.20.x для совместимой сборки|
|Java|temurin-17.x||
|Android SDK|36.1||
|Android NDK|27.0.12077973<br>28.2.13676358|core<br>app|
|Rust|Последняя стабильная||

### Сборка и упаковка

#### Windows

* Минимальные требования: Windows 10 1809
* Toolchain: Flutter, Golang, Cargo, Visual Studio ≥ 2022
* Упаковка exe: Inno Setup

```powershell
# Сборка и упаковка
flutter pub get
dart run build_runner build -d
dart .\setup.dart windows
```

#### Linux

* Toolchain: Flutter, Golang, Clang, CMake, Ninja, pkg-config
* Зависимости: libcurl4, gtk3, libayatana-appindicator, libkeybinder3, libfuse2 (для AppImage)
* Упаковка DEB: dpkg-deb
* Упаковка RPM: rpm, patchelf
* Упаковка AppImage: appimagetool, locate, libfuse2

```bash
# Установка зависимостей
## На примере Ubuntu 24.04, устанавливайте по необходимости
sudo apt install build-essential clang cmake ninja-build
sudo apt install libcurl4-openssl-dev libgtk-3-dev lbayatana-appindicator3-dev libkeybinder-3.0-dev libfuse2
sudo apt install dpkg-deb rpm patchelf locate
wget https://github.com/Appimage/AppimageKit/releases/download/containuous/appimagetool-x86_64.AppImage
chmod +x appimagetool
sudo mv appimagetool /usr/local/bin/

# Сборка и упаковка
## Укажите параметр --targets по необходимости, используйте "," для разделения
flutter pub get
dart run build_runner build -d
dart setup.dart linux --targets=deb,rpm,appimage
# Только сборка
dart setup.dart linux --build-only
```

#### Mac OS

* Toolchain: Flutter, Golang, Xcode command-line tools, CocoaPods
* Упаковка: appdmg

```zsh
# Установка зависимостей
npm install appdmg
# Сборка и упаковка
flutter pub get
dart run build_runner build -d
dart setup.dart macos
```

#### Android

* Toolchain: Flutter, Golang, CMake, Android SDK, Android SDK Build-Tools, Android SDK Command-line Tools (опционально: отдельный sdkmanager), Android SDK Platform-Tools, Android NDK

1. Настройка среды сборки

  * Android SDK, NDK и Tools

    * Настройка через Android Studio

      См. [официальную документацию Flutter](https://docs.flutter.dev/platform-integration/android/setup)

    * Установка из командной строки (на примере Linux)

      ```bash
      # Настройка переменных окружения
      echo 'export ANDROID_HOME=$HOME/.local/opt/android-sdk' >> ~/.bashrc
      echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' >> ~/.bashrc
      sourec ~/.bashrc

      # Установка SDK, NDK, Tools
      ## Используйте sdkmanager.py
      sudo apt install sdkmanager
      sdkmanager --install "build-tools;36.0.0" "cmdline-tools;latest" "platform-tools" "platforms;android-36.1" "ndk;27.0.12077973" "ndk;28.2.13676358"

      # Принятие лицензий
      flutter doctor --android-lincenses
      ```

  * Настройка Keystore

    1. Создайте новый Keystore или импортируйте существующий в `./android/app/keystore.jks`
    2. (без Android Studio) Создайте или откройте `./android/local.properties`, добавьте следующие параметры

      ```properties
      keyAlias=<ключ псевдоним>
      storePassword=<пароль Keystore>
      keyPassword=<пароль ключа>
      ```
  * Запустите `flutter doctor` для проверки целостности среды сборки

2. Сборка и упаковка

  ```bash
  flutter pub get
  dart run build-runner build -d
  dart setup.dart android --arch=universal
  ```

#### Советы и примечания

1. Текущая версия flutter_distributor (v0.4.2) содержит жестко заданный путь установки Inno Setup (`C:\Program Files (x86)\Inno Setup 6`), убедитесь, что Inno Setup установлен от имени администратора в каталог по умолчанию
2. Используйте параметр `--compatible` для сборки под [старые CPU](https://go.dev/wiki/MinimumRequirements#amd64)
3. Выполните `dart setup.dart help <platform>` для просмотра дополнительных опций командной строки

### Отладка (VS Code)

На примере Windows

1. Убедитесь, что core предварительно собран
```powershell
dart .\setup.dart windows --out core --dev --ensure
```
2. Подключите целевое устройство и нажмите F5 для начала отладки

---

### ☕ Спонсорская поддержка

**Если этот проект был вам полезен, вы можете поддержать разработку следующими способами:**

* TRON (TRC-20): <code>TCkTtZfF2WrciZLaJj3e1aqrh3zdTnCkDa</code>
* EVM Compatible: <code>0xF8B1B39431013359D83F38a4e403087624618E67</code>
* Solana: <code>C2YQPcKR2YmrPtBvkE13wckjgescUfMA5HzUioR4rQUd</code>
* Bitcoin: <code>bc1qu950cl6035qvllmzk6cfw3l30j2lg3cq9n6g6h</code>

---

## ❤️ Благодарности

**[FlClash GUI](https://github.com/chen08209/FlClash)** - **[Mihomo Core](https://github.com/MetaCubeX/mihomo)**

* Цифровая подпись Windows для проекта Bettbox предоставлена **[SignPath](https://signpath.io)**, и код прошёл аудит безопасности.
* Искренняя благодарность фонду **SignPath Foundation** за активную поддержку сообщества открытого исходного кода.

Другие проекты (в хронологическом порядке):

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 Лицензия

Проект распространяется на условиях лицензии GPL-3.0.
