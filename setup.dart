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

class BuildItem {
  TargetPlatform platform;
  Arch? arch;
  String? archName;

  BuildItem({required this.platform, this.arch, this.archName});

  @override
  String toString() {
    return 'BuildLibItem{platform: $platform, arch: $arch, archName: $archName}';
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

  static String _getCc(BuildItem buildItem) {
    final environment = Platform.environment;
    if (buildItem.platform == TargetPlatform.android) {
      final ndk = environment['ANDROID_NDK'];
      assert(ndk != null);
      final prebuiltDir = Directory(
        join(ndk!, 'toolchains', 'llvm', 'prebuilt'),
      );
      final prebuiltDirList = prebuiltDir.listSync();
      final map = {
        'armeabi-v7a': 'armv7a-linux-androideabi21-clang',
        'arm64-v8a': 'aarch64-linux-android21-clang',
        'x86': 'i686-linux-android21-clang',
        'x86_64': 'x86_64-linux-android21-clang',
      };
      return join(prebuiltDirList.first.path, 'bin', map[buildItem.archName]);
    }
    return 'gcc';
  }

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

  static Future<void> _checkCoreDependencies(String? cgoCc) async {
    final missing = <String>[];
    final requiredCmds = ['go'];
    if (cgoCc != null) requiredCmds.add(cgoCc);

    for (final cmd in requiredCmds) {
      bool exists;
      if (Platform.isWindows) {
        final result = await Process.run('where', [cmd]);
        exists = result.exitCode == 0;
      } else {
        final result = await Process.run('which', [cmd]);
        exists = result.exitCode == 0;
      }
      if (!exists) missing.add(cmd);
    }
    if (missing.isNotEmpty) {
      throw 'Missing required dependencies: ${missing.join(", ")}. '
          'Please install them first. See README for details.';
    }
  }

  static Future<List<String>> buildCore({
    required CoreMode mode,
    required TargetPlatform platform,
    Arch? arch,
    bool compatible = false,
  }) async {
    final isLib = mode == CoreMode.lib;

    final items = buildItems.where((element) {
      return element.platform == platform &&
          (arch == null ? true : element.arch == arch);
    }).toList();

    final List<String> corePaths = [];

    for (final item in items) {
      final outFileDir = join(outDir, item.platform.name, item.archName);

      final file = File(outFileDir);
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }

      final fileName = isLib
          ? '$libName${item.platform.dynamicLibExtensionName}'
          : '$coreName${item.platform.executableExtensionName}';
      final outPath = join(outFileDir, fileName);
      corePaths.add(outPath);

      final Map<String, String> env = {};
      env['GOOS'] = item.platform.os;
      if (item.arch != null) {
        env['GOARCH'] = item.arch!.name;
      }
      if (item.arch == Arch.amd64 &&
          (item.platform == TargetPlatform.windows ||
              item.platform == TargetPlatform.linux ||
              item.platform == TargetPlatform.macos)) {
        env['GOAMD64'] = compatible ? 'v1' : 'v3';
      }
      if (isLib) {
        env['CGO_ENABLED'] = '1';
        env['CC'] = _getCc(item);
        env['CFLAGS'] = '-O3 -Werror';
      } else {
        env['CGO_ENABLED'] = '0';
      }

      final buildTags = getTags(item);
      
      await _checkCoreDependencies(env['CC']);

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
        name: 'build core',
        environment: env,
        workingDirectory: _coreDir,
      );
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
      .where((element) => element.platform == platform && element.arch != null)
      .map((e) => e.arch!)
      .toList();
  
  static Future<void> _checkLinuxDependencies(String targets) async {
    final missing = <String>[];

    final requiredCmds = ['clang', 'cmake', 'pkg-config', 'ninja'];
    if (targets.contains('deb')) {
      requiredCmds.add('dpkg-deb');
    }
    if (targets.contains('rpm')) {
      requiredCmds.add('rpm');
    }
    if (targets.contains('appimage')) {
      requiredCmds.addAll(['appimagetool', 'patchelf']);
    }
    for (final cmd in requiredCmds) {
      final result = await Process.run('which', [cmd]);
      if (result.exitCode != 0) {
        missing.add(cmd);
      }
    }

    final requiredLibs = {
      'gtk+-3.0': 'gtk3',
      'ayatana-appindicator3-0.1': 'libayatana-appindicator',
      'keybinder-3.0': 'keybinder-3.0',
      'libcurl': 'libcurl',
    };
    if (targets.contains('appimage')) {
      // requiredLibs['fuse'] = 'libfuse2';
      // libfuse2 是 appimagetool 的运行时依赖，不适用 pkg-config
      final result = await Process.run(
        'sh', ['-c', 'ldconfig -p | grep -q libfuse.so.2']
      );
      if (result.exitCode != 0) {
        missing.add('libfuse2');
      }
    }
    for (final entry in requiredLibs.entries) {
      final result = await Process.run('pkg-config', ['--exists', entry.key]);
      if (result.exitCode != 0) {
        missing.add(entry.value);
      }
    }

    if (missing.isNotEmpty) {
      throw 'Missing required dependencies: ${missing.join(", ")}. '
          'Please install them first. See README for details.';
    }
  }

  static Future<void> _checkMacosDependencies() async {
    final result = await Process.run('which', ['appdmg']);
    if (result.exitCode != 0) {
      throw 'Missing appdmg. Please install it with npm.';
    }
  }

  Future<void> _setMacOSCompatibleBuild(bool enable) async {
    final infoPlistPath = 'macos/Runner/Info.plist';
    final file = File(infoPlistPath);

    if (!await file.exists()) {
      print('Warning: Info.plist not found at $infoPlistPath');
      return;
    }

    var content = await file.readAsString();

    // Check if FLTDisableImpeller key exists
    if (content.contains('<key>FLTDisableImpeller</key>')) {
      // Update existing key
      if (enable) {
        content = content.replaceAll(
          RegExp(r'<key>FLTDisableImpeller</key>\s*<(?:true|false)/>'),
          '<key>FLTDisableImpeller</key>\n\t<true/>',
        );
      } else {
        content = content.replaceAll(
          RegExp(r'<key>FLTDisableImpeller</key>\s*<(?:true|false)/>'),
          '<key>FLTDisableImpeller</key>\n\t<false/>',
        );
      }
    } else {
      // Add new key before </dict>
      final impellerEntry = enable
          ? '\t<key>FLTDisableImpeller</key>\n\t<true/>\n'
          : '\t<key>FLTDisableImpeller</key>\n\t<false/>\n';
      content = content.replaceFirst(
        '</dict>\n</plist>',
        '$impellerEntry</dict>\n</plist>',
      );
    }

    await file.writeAsString(content);
    print(
      'macOS ${enable ? "Compatible" : "Standard"} build: FLTDisableImpeller set to $enable',
    );
  }

  Future<void> _buildDistributor({
    required TargetPlatform platform,
    required String targets,
    String args = '',
    required String env,
  }) async {
    final sentryDsn = Platform.environment['SENTRY_DSN'] ?? '';
    final sentryArg = sentryDsn.isNotEmpty
        ? ' --build-dart-define=SENTRY_DSN=$sentryDsn'
        : '';

    await Build.getDistributor();
    await Build.exec(
      name: name,
      Build.getExecutable(
        'flutter_distributor package --skip-clean --platform ${platform.name} --targets $targets --flutter-build-args=verbose$args$sentryArg --build-dart-define=APP_ENV=$env',
      ),
    );
  }

  Future<String?> get systemArch async {
    if (Platform.isWindows) {
      return Platform.environment['PROCESSOR_ARCHITECTURE'];
    } else if (Platform.isLinux || Platform.isMacOS) {
      final result = await Process.run('uname', ['-m']);
      return result.stdout.toString().trim();
    }
    return null;
  }

  @override
  Future<void> run() async {
    final coreMode = platform == TargetPlatform.android ? CoreMode.lib : CoreMode.core;
    final String out = argResults?['out'] ?? (platform.same ? 'app' : 'core');
    final archName = argResults?['arch'];
    final env = argResults?['env'] ?? 'pre';
    final currentArches = arches
        .where((element) => element.name == archName)
        .toList();
    final arch = currentArches.isEmpty ? null : currentArches.first;

    if (arch == null && platform != TargetPlatform.android) {
      throw 'Invalid arch parameter';
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

    final String desc = compatible ? '$archName-compatible' : (archName ?? '');

    switch (platform) {
      case TargetPlatform.windows:
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
        await _checkLinuxDependencies(targets);
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

        final buildArgs = archName == 'universal'
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
        await _checkMacosDependencies();
        // For compatible build, disable Impeller and use Skia renderer
        if (compatible) {
          await _setMacOSCompatibleBuild(true);
        } else {
          await _setMacOSCompatibleBuild(false);
        }
        _buildDistributor(
          platform: platform,
          targets: 'dmg',
          args: ' --description $desc',
          env: env,
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
