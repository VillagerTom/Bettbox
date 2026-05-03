// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';

enum TargetPlatform { windows, linux, android, macos }

extension PlatformExt on TargetPlatform {
  String get os {
    if (this == TargetPlatform.macos) {
      return 'darwin';
    }
    return name;
  }

  bool get same {
    if (this == TargetPlatform.android) {
      return true;
    }
    if (Platform.isWindows && this == TargetPlatform.windows) {
      return true;
    }
    if (Platform.isLinux && this == TargetPlatform.linux) {
      return true;
    }
    if (Platform.isMacOS && this == TargetPlatform.macos) {
      return true;
    }
    return false;
  }

  String get dynamicLibExtensionName {
    final String extensionName;
    switch (this) {
      case TargetPlatform.android || TargetPlatform.linux:
        extensionName = '.so';
        break;
      case TargetPlatform.windows:
        extensionName = '.dll';
        break;
      case TargetPlatform.macos:
        extensionName = '.dylib';
        break;
    }
    return extensionName;
  }

  String get executableExtensionName {
    final String extensionName;
    switch (this) {
      case TargetPlatform.windows:
        extensionName = '.exe';
        break;
      default:
        extensionName = '';
        break;
    }
    return extensionName;
  }
}

enum CoreMode { core, lib }

enum Arch { amd64, arm64, arm }

extension ArchExt on Arch {
  Map<String, String> get archMap {
    switch (Platform.operatingSystem) {
      case 'windows':
        return {
          'AMD64': 'amd64',
          'x86': 'amd32',
          'ARM64': 'arm64',
          'ARM': 'arm'
        };
      case 'linux' || 'android':
        return {
          'x86_64': 'amd64',
          'i386': 'amd32',
          'i486': 'amd32',
          'i586': 'amd32',
          'i686': 'amd32',
          'aarch64': 'arm64',
          'armv5l': 'arm',
          'armv6l': 'arm',
          'armv7l': 'arm'
        };
      case 'macos':
        return {
          'x86_64': 'amd64',
          'arm64': 'arm64',
          'arm64e': 'arm64'
        };
      default:
        throw 'Unsupported platform!';
    }
  }

  bool get same {
    final String hostArchName;
    if (Platform.isWindows) {
      hostArchName = Platform.environment['PROCESSOR_ARCHITECTURE']!;
    } else {
      var info = Process.runSync('uname', ['-m']);
      hostArchName = info.stdout.toString().trim();
    }
    final hostArch = archMap[hostArchName] ?? hostArchName;
    return name == hostArch ? true : false;
  }
}

class BuildItem {
  TargetPlatform platform;
  Arch arch;
  String? archName;

  BuildItem({required this.platform, required this.arch, this.archName});

  @override
  String toString() {
    return 'BuildLibItem{platform: $platform, arch: $arch, archName: $archName}';
  }
}

Future<void> checkDeps({
  List<String>? commands,
  Map<String, String>? devLibs,
  Map<String, String>? rtLibs,
  List<String>? files,
  List<String>? ndks,
}) async {
  final missing = <String>[];

  if (devLibs != null) {
    final pkgConfigExists = (await Process.run('which', ['pkg-config'])).exitCode == 0;
    if (!pkgConfigExists) {
      missing.add('pkg-config');
    } else {
      for (final entry in devLibs.entries) {
        final result = await Process.run('pkg-config', ['--exists', entry.value]);
        if (result.exitCode != 0) missing.add(entry.key);
      }
    }
  }
  
  if (rtLibs != null) {
    for (final entry in rtLibs.entries) {
      final result = await Process.run('sh', ['-c', 'ldconfig -p | grep $entry.value']);
      if (result.exitCode != 0) missing.add(entry.key);
    }
  }

  if (ndks != null) {
    final sdkmanager = join(Platform.environment['ANDROID_HOME']!, 'cmdline-tools', 'latest', 'bin', 'sdkmanager');
    final cmdlineToolsExist = File(sdkmanager).existsSync();
    if (!cmdlineToolsExist) {
      missing.add('Android SDK Command-line Tools');
    } else {
      for (final ndkVersion in ndks) {
        final result = await Process.run(sdkmanager, ['--list_installed']);
        final pattern = RegExp('^\\s.${RegExp.escape('ndk;$ndkVersion')}', multiLine: true);
        final installed = pattern.hasMatch(result.stdout);
        if (!installed) {
          missing.add('Android NDK $ndkVersion');
        }
      }
    }
  }

  if (commands != null) {
    for (final cmd in commands) {
      final result = Platform.isWindows
          ? await Process.run('where.exe', [cmd])
          : await Process.run('which', [cmd]);
      if (result.exitCode != 0) {
        missing.add(cmd);
      }
    }
  }
  

  if (files != null) {
    for (final filePath in files) {
      if (!File(filePath).existsSync()) {
        missing.add(basename(filePath));
      }
    }
  }

  if (missing.isNotEmpty) {
    throw 'Missing required dependencies: ${missing.join(", ")}. '
        'Please install them first. See README for details.';
  }
}

class Build {
  static List<BuildItem> get buildItems => [
    BuildItem(platform: TargetPlatform.macos, arch: Arch.arm64),
    BuildItem(platform: TargetPlatform.macos, arch: Arch.amd64),
    BuildItem(platform: TargetPlatform.linux, arch: Arch.arm64),
    BuildItem(platform: TargetPlatform.linux, arch: Arch.amd64),
    BuildItem(platform: TargetPlatform.windows, arch: Arch.amd64),
    BuildItem(platform: TargetPlatform.windows, arch: Arch.arm64),
    BuildItem(
      platform: TargetPlatform.android,
      arch: Arch.arm,
      archName: 'armeabi-v7a',
    ),
    BuildItem(
      platform: TargetPlatform.android,
      arch: Arch.arm64,
      archName: 'arm64-v8a',
    ),
    BuildItem(
      platform: TargetPlatform.android,
      arch: Arch.amd64,
      archName: 'x86_64',
    ),
  ];

  static String get appName => 'Bettbox';

  static String get coreName => 'BettboxCore';

  static String get libName => 'libclash';

  static String get outDir => join(current, libName);

  static String get _coreDir => join(current, 'core');

  static String get _servicesDir => join(current, 'services', 'helper');

  static String get distPath => join(current, 'dist');

  static String getTags(BuildItem buildItem) {
    final baseTags = 'with_gvisor,no_fake_tcp';
    if (buildItem.platform == TargetPlatform.android &&
        buildItem.archName == 'armeabi-v7a') {
      return '$baseTags,with_low_memory';
    }
    return baseTags;
  }

  static Future<void> exec(
    List<String> executable, {
    String? name,
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = true,
  }) async {
    if (name != null) print('run $name');
    final process = await Process.start(
      executable[0],
      executable.sublist(1),
      environment: environment,
      workingDirectory: workingDirectory,
      runInShell: runInShell,
    );
    process.stdout.listen((data) {
      print(utf8.decode(data));
    });
    process.stderr.listen((data) {
      print(utf8.decode(data));
    });
    final exitCode = await process.exitCode;
    if (exitCode != 0 && name != null) throw '$name error';
  }

  static Future<String> calcSha256(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw 'File not exists';
    }
    final stream = file.openRead();
    return sha256.convert(await stream.reduce((a, b) => a + b)).toString();
  }

  static Future<List<String>> buildCore({
    required CoreMode mode,
    required TargetPlatform platform,
    Arch? arch,
    bool compatible = false,
  }) async {
    final isLib = mode == CoreMode.lib;

    final items = buildItems.where((element) {
      return element.platform == platform && (arch == null || element.arch == arch);
    }).toList();
    final isMultiArch = items.length > 1;
    final List<String> corePaths = [];
    final List<String> macOSCorePaths = [];
    for (final item in items) {
      final outFileDir = join(
        outDir,
        item.platform.name, 
        item.platform == TargetPlatform.macos ? item.arch.name : item.archName
      );

      final file = File(outFileDir);
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }

      final fileName = isLib
          ? '$libName${item.platform.dynamicLibExtensionName}'
          : '$coreName${item.platform.executableExtensionName}';
      final outPath = join(outFileDir, fileName);
      if (item.platform == TargetPlatform.macos) {
        macOSCorePaths.add(outPath);
      } else {
        corePaths.add(outPath);
      }

      final Map<String, String> env = {};
      env['GOOS'] = item.platform.os;
      env['GOARCH'] = item.arch.name;
      if (item.arch == Arch.amd64 &&
          (item.platform == TargetPlatform.windows ||
              item.platform == TargetPlatform.linux ||
              item.platform == TargetPlatform.macos)) {
        env['GOAMD64'] = compatible ? 'v1' : 'v3';
      }
      if (isLib) {
        env['CGO_ENABLED'] = '1';
        env['CFLAGS'] = '-O3 -Werror';
        if (item.platform == TargetPlatform.android) {
          var ndkPath = Platform.environment['ANDROID_NDK'];
          if (ndkPath == null) {
            const ndkVersion = '27.0.12077973';
            final androidHome = Platform.environment['ANDROID_HOME']!;
            await checkDeps(ndks: [ndkVersion]);
            ndkPath = join(androidHome, 'ndk', ndkVersion);
          }
          final prebuiltDir = Directory(join(ndkPath, 'toolchains', 'llvm', 'prebuilt'));
          final map = {
            'armeabi-v7a': 'armv7a-linux-androideabi21-clang',
            'arm64-v8a': 'aarch64-linux-android21-clang',
            'x86': 'i686-linux-android21-clang',
            'x86_64': 'x86_64-linux-android21-clang',
          };
          env['CC'] = join(prebuiltDir.listSync().first.path, 'bin', map[item.archName]);
        } else {
          env['CC'] = 'gcc';
          await checkDeps(commands: ['gcc']);
        }
      } else {
        env['CGO_ENABLED'] = '0';
      }

      final buildTags = getTags(item);

      await checkDeps(commands: ['go']);
      await exec(
        ['go', 'mod', 'tidy'],
        name: 'go mod tidy',
        environment: env,
        workingDirectory: _coreDir,
      );

      final execLines = [
        'go',
        'build',
        '-trimpath',
        '-ldflags=-w -s${item.platform == TargetPlatform.android && (item.arch == Arch.arm64 || item.arch == Arch.amd64) ? ' -extldflags "-Wl,-z,max-page-size=16384"' : ''}',
        '-tags=$buildTags',
        if (isLib) '-buildmode=c-shared',
        '-o',
        outPath,
      ];
      await exec(
        execLines,
        name: 'build core ${isMultiArch ? "(${item.archName ?? item.arch.name})" : ""}',
        environment: env,
        workingDirectory: _coreDir,
      );
    }
    if (macOSCorePaths.isNotEmpty) {
      final outFileDir = join(outDir, TargetPlatform.macos.name);
      final fileName = isLib
          ? '$libName${TargetPlatform.macos.dynamicLibExtensionName}'
          : '$coreName${TargetPlatform.macos.executableExtensionName}';
      final outPath = join(outFileDir, fileName);

      await exec(
        macOSCorePaths.length > 1
        ? ['lipo', '-create', '-output', outPath, ...macOSCorePaths]
        : ['cp', macOSCorePaths.first, outPath]
      );
      corePaths.add(outPath);
    }
    return corePaths;
  }

  static Future<void> buildHelper(TargetPlatform platform, String token) async {
    await exec(
      ['cargo', 'build', '--release', '--features', 'windows-service'],
      environment: {'TOKEN': token},
      name: 'build helper',
      workingDirectory: _servicesDir,
    );
    final outPath = join(
      _servicesDir,
      'target',
      'release',
      'helper${platform.executableExtensionName}',
    );
    final targetPath = join(
      outDir,
      platform.name,
      'BettboxHelperService${platform.executableExtensionName}',
    );
    await File(outPath).copy(targetPath);
  }

  static List<String> getExecutable(String command) {
    return command.split(' ');
  }

  static Future<void> getDistributor() async {
    final distributorDir = join(
      current,
      'plugins',
      'flutter_distributor',
      'packages',
      'flutter_distributor',
    );

    await exec(
      name: 'clean distributor',
      Build.getExecutable('flutter clean'),
      workingDirectory: distributorDir,
    );
    await exec(
      name: 'upgrade distributor',
      Build.getExecutable('flutter pub upgrade'),
      workingDirectory: distributorDir,
    );
    await exec(
      name: 'get distributor',
      Build.getExecutable('dart pub global activate -s path $distributorDir'),
    );
  }

  static void copyFile(String sourceFilePath, String destinationFilePath) {
    final sourceFile = File(sourceFilePath);
    if (!sourceFile.existsSync()) {
      throw 'SourceFilePath not exists';
    }
    final destinationFile = File(destinationFilePath);
    final destinationDirectory = destinationFile.parent;
    if (!destinationDirectory.existsSync()) {
      destinationDirectory.createSync(recursive: true);
    }
    try {
      sourceFile.copySync(destinationFilePath);
      print('File copied successfully!');
    } catch (e) {
      print('Failed to copy file: $e');
    }
  }
}

class BuildCommand extends Command {
  TargetPlatform platform;

  //TODO: Delete arg option 'targets' for android
  BuildCommand({required this.platform}) {
    if (platform == TargetPlatform.android ||
        platform == TargetPlatform.linux) {
      argParser.addOption(
        'arch',
        valueHelp: arches.map((e) => e.name).join(','),
        help: 'The $name build desc',
      );
      argParser.addOption(
        'targets',
        valueHelp: 'deb,zip,appimage,rpm',
        help: 'The linux package formats (comma separated)',
      );
    } else {
      argParser.addOption('arch', help: 'The $name build archName');
    }
    argParser.addOption(
      'out',
      valueHelp: [if (platform.same) 'app', 'core'].join(','),
      help: 'The $name build arch',
    );
    argParser.addOption(
      'env',
      valueHelp: ['pre', 'stable'].join(','),
      help: 'The $name build env',
    );
    argParser.addFlag(
      'compatible',
      help: 'Build with GOAMD64=v2 for broader compatibility on amd64',
    );
  }

  @override
  String get description => 'build $name application';

  @override
  String get name => platform.name;

  List<Arch> get arches => Build.buildItems
      .where((element) => element.platform == platform)
      .map((e) => e.arch)
      .toList();

  Future<void> _buildDistributor({
    required TargetPlatform platform,
    required String targets,
    String args = '',
    required String env,
    Map<String, String>? buildEnv,
  }) async {
    final sentryDsn = Platform.environment['SENTRY_DSN'] ?? '';
    final sentryArg = sentryDsn.isNotEmpty
        ? ' --build-dart-define=SENTRY_DSN=$sentryDsn'
        : '';

    await Build.getDistributor();
    await Build.exec(
      name: description,
      environment: buildEnv,
      Build.getExecutable(
        'flutter_distributor package --skip-clean --platform ${platform.name} --targets $targets --flutter-build-args=verbose$args$sentryArg --build-dart-define=APP_ENV=$env',
      ),
    );
  }

  @override
  Future<void> run() async {
    final coreMode = platform == TargetPlatform.android ? CoreMode.lib : CoreMode.core;
    final String out = argResults?['out'] ?? (platform.same ? 'app' : 'core');
    final String? archParam = argResults?['arch'];
    final String env = argResults?['env'] ?? 'pre';
    Arch? arch = arches.where((element) => element.name == archParam).firstOrNull;

    if (platform != TargetPlatform.android && platform != TargetPlatform.macos) {
      arch ??= arches.where((element) => element.same).first;
      if (!arch.same && platform == TargetPlatform.linux) {
        throw 'Corss-build to $name ${arch.name} target is not currently supported!';
      }
    }

    final bool compatible = argResults?['compatible'] ?? false;

    final corePaths = await Build.buildCore(
      platform: platform,
      arch: arch,
      mode: coreMode,
      compatible: compatible,
    );

    if (out != 'app') {
      if (!platform.same) print('Platform incompatible, core built only!');
      return;
    }

    final String desc = '$archParam${compatible ? "-compatible" : ""}';

    switch (platform) {
      case TargetPlatform.windows:
        // TODO: Add checks for Windows ARM
        await checkDeps(
          commands: ['cargo'],
          files: [r'C:\Program Files (x86)\Inno Setup 6\ISCC.exe'],
        );
        final token = platform != TargetPlatform.android
            ? await Build.calcSha256(corePaths.first)
            : null;
        Build.buildHelper(platform, token!);
        _buildDistributor(
          platform: platform,
          targets: 'exe',
          args: ' --description $desc --build-dart-define=CORE_SHA256=$token',
          env: env,
        );
        return;
      case TargetPlatform.linux:
        final targetMap = {Arch.arm64: 'linux-arm64', Arch.amd64: 'linux-x64'};
        final targets = argResults?['targets'];
        if (targets == null || targets.trim().isEmpty) {
          throw 'Invalid targets parameter';
        }
        final defaultTarget = targetMap[arch];
        
        final requiredCmds = ['clang', 'cmake', 'ninja'];
        final requiredRtLibs = <Map<String, String>>[];
        if (targets.contains('deb')) requiredCmds.add('dpkg-deb');
        if (targets.contains('rpm')) requiredCmds.addAll(['rpm', 'patchelf']);
        if (targets.contains('appimage')) {
          requiredCmds.addAll(['appimagetool', 'locate']);
          requiredRtLibs.add({'libfuse2': 'libfuse.so.2'});
        }
        await checkDeps(
          commands: requiredCmds,
          devLibs: {
            'gtk3': 'gtk+-3.0',
            'libayatana-appindicator': 'ayatana-appindicator3-0.1',
            'keybinder-3.0': 'keybinder-3.0',
            'libcurl': 'libcurl',
          }
        );

        _buildDistributor(
          platform: platform,
          targets: targets,
          args: ' --description $desc --build-target-platform $defaultTarget',
          env: env,
        );
        return;
      case TargetPlatform.android:
        final targetMap = {
          Arch.arm: 'android-arm',
          Arch.arm64: 'android-arm64',
          Arch.amd64: 'android-x64',
        };
        final defaultArches = [Arch.arm, Arch.arm64, Arch.amd64];
        final defaultTargets = defaultArches
            .where((element) => arch == null ? true : element == arch)
            .map((e) => targetMap[e])
            .toList();

        final buildArgs = archParam == 'universal'
            ? ' --build-target-platform ${defaultTargets.join(",")} --description universal'
            : ',split-per-abi --build-target-platform ${defaultTargets.join(",")}';

        _buildDistributor(
          platform: platform,
          targets: 'apk',
          args: buildArgs,
          env: env,
        );
        return;
      case TargetPlatform.macos:
        await checkDeps(commands: ['appdmg']);

        // For compatible build, disable Impeller and use Skia renderer
        final infoPlist = File('macos/Runner/Info.plist');
        if (await infoPlist.exists()) {
          var content = await infoPlist.readAsString();

          // Check if FLTDisableImpeller key exists
          if (content.contains('<key>FLTDisableImpeller</key>')) {
            content = content.replaceAll(
              RegExp(r'<key>FLTDisableImpeller</key>\s*<(?:true|false)/>'),
              '<key>FLTDisableImpeller</key>\n\t<$compatible/>',
            );
          } else {
            // Add new key before </dict>
            final impellerEntry = '\t<key>FLTDisableImpeller</key>\n\t<$compatible/>\n';
            content = content.replaceFirst(
              '</dict>\n</plist>',
              '$impellerEntry</dict>\n</plist>',
            );
          }
          await infoPlist.writeAsString(content);
          print('macOS ${compatible ? "Compatible" : "Standard"} build: FLTDisableImpeller set to $compatible');
        } else {
          print('Warning: ${infoPlist.path} not found!');
        }
        
        // FIXME: still builds two core when arch param is null
        final archName = archParam == 'universal'
          ? null
          : arch?.archMap.keys.firstWhere((k) => arch?.archMap[k] == arch?.name);
        final buildEnv = archName == null ? null : {'FLUTTER_XCODE_ARCHS': archName};
        _buildDistributor(
          platform: platform,
          targets: 'dmg',
          args: ' --description $desc',
          env: env,
          buildEnv: buildEnv,
        );
        return;
    }
  }
}

Future<void> main(Iterable<String> args) async {
  final runner = CommandRunner('setup', 'build Application');
  runner.addCommand(BuildCommand(platform: TargetPlatform.android));
  runner.addCommand(BuildCommand(platform: TargetPlatform.linux));
  runner.addCommand(BuildCommand(platform: TargetPlatform.windows));
  runner.addCommand(BuildCommand(platform: TargetPlatform.macos));
  runner.run(args);
}
