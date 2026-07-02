// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';

enum Target { windows, linux, android, macos }

extension TargetExt on Target {
  String get os {
    if (this == Target.macos) {
      return 'darwin';
    }
    return name;
  }

  bool get same => name == Platform.operatingSystem;

  bool get buildable {
    return same || this == Target.android;
  }

  String get dynamicLibExtensionName {
    final String extensionName;
    switch (this) {
      case Target.android || Target.linux:
        extensionName = '.so';
        break;
      case Target.windows:
        extensionName = '.dll';
        break;
      case Target.macos:
        extensionName = '.dylib';
        break;
    }
    return extensionName;
  }

  String get executableExtensionName {
    final String extensionName;
    switch (this) {
      case Target.windows:
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
          'ARM': 'arm',
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
          'armv7l': 'arm',
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

  String get hostArchName {
    if (_hostArchName != null) return _hostArchName!;
    final String raw;
    if (Platform.isWindows) {
      raw = Platform.environment['PROCESSOR_ARCHITECTURE']!;
    } else {
      raw = Process.runSync('uname', ['-m']).stdout.toString().trim();
    }
    return _hostArchName = archMap[raw] ?? raw;
  }

  bool get same => name == hostArchName;
}

String? _hostArchName;

class BuildItem {
  Target target;
  Arch arch;
  String? archName;

  BuildItem({required this.target, required this.arch, this.archName});

  @override
  String toString() {
    return 'BuildLibItem{target: $target, arch: $arch, archName: $archName}';
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

  if (devLibs != null && devLibs.isNotEmpty) {
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

  if (rtLibs != null && rtLibs.isNotEmpty) {
    for (final entry in rtLibs.entries) {
      final result = await Process.run('sh', ['-c', 'ldconfig -p | grep ${entry.value}']);
      if (result.exitCode != 0) missing.add(entry.key);
    }
  }

  if (ndks != null && ndks.isNotEmpty) {
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

  if (commands != null && commands.isNotEmpty) {
    for (final cmd in commands) {
      final result = Platform.isWindows
          ? await Process.run('where.exe', [cmd])
          : await Process.run('which', [cmd]);
      if (result.exitCode != 0) {
        missing.add(cmd);
      }
    }
  }

  if (files != null && files.isNotEmpty) {
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
  static bool isDev = false;

  static String get identityName => isDev ? '${appName}Dev' : appName;

  static List<BuildItem> get buildItems => [
    BuildItem(target: Target.macos, arch: Arch.arm64),
    BuildItem(target: Target.macos, arch: Arch.amd64),
    BuildItem(target: Target.linux, arch: Arch.arm64),
    BuildItem(target: Target.linux, arch: Arch.amd64),
    BuildItem(target: Target.windows, arch: Arch.amd64),
    BuildItem(target: Target.windows, arch: Arch.arm64),
    BuildItem(
      target: Target.android,
      arch: Arch.arm,
      archName: 'armeabi-v7a',
    ),
    BuildItem(
      target: Target.android,
      arch: Arch.arm64,
      archName: 'arm64-v8a',
    ),
    BuildItem(
      target: Target.android,
      arch: Arch.amd64,
      archName: 'x86_64',
    ),
  ];

  static String get appName => 'Bettbox';

  static String get coreName => '${identityName}Core';

  static String get helperName => '${identityName}HelperService';

  static String get libName => 'libmeta';

  static String get outDir => join(current, 'libclash');

  static String get _coreDir => join(current, 'core');

  static String get _servicesDir => join(current, 'services', 'helper');

  static String get distPath => join(current, 'dist');

  static String getTags(BuildItem buildItem) {
    final baseTags = 'with_gvisor';
    if (buildItem.target == Target.android &&
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
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  static Future<List<String>> buildCore({
    required CoreMode mode,
    required Target target,
    Arch? arch,
    bool compatible = false,
  }) async {
    final isLib = mode == CoreMode.lib;

    final items = buildItems.where((element) {
      return element.target == target && (arch == null || element.arch == arch);
    }).toList();

    final List<String> corePaths = [];

    for (final item in items) {
      final outFileDir = join(outDir, item.target.name, item.archName);

      final file = File(outFileDir);
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }

      final fileName = isLib
          ? '$libName${item.target.dynamicLibExtensionName}'
          : '$coreName${item.target.executableExtensionName}';
      final outPath = join(outFileDir, fileName);
      corePaths.add(outPath);

      final Map<String, String> env = {};
      env['GOOS'] = item.target.os;
      env['GOARCH'] = item.arch.name;
      if (item.arch == Arch.amd64 && item.target == Target.macos) {
        env['GOAMD64'] = 'v1';
      } else if (item.arch == Arch.amd64 &&
          (item.target == Target.windows || item.target == Target.linux)) {
        env['GOAMD64'] = compatible ? 'v1' : 'v3';
      }
      if (isLib) {
        env['CGO_ENABLED'] = '1';
        env['CFLAGS'] = '-O3 -Werror';
        if (item.target == Target.android) {
          var ndkPath = Platform.environment['ANDROID_NDK'];
          if (ndkPath == null) {
            const ndkVersion = '28.2.13676358';
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
        '-ldflags=-w -s${item.target == Target.android && (item.arch == Arch.arm64 || item.arch == Arch.amd64) ? ' -extldflags "-Wl,-z,max-page-size=16384"' : ''}',
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

  static Future<void> buildHelper(Target target, String token) async {
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
      'helper${target.executableExtensionName}',
    );
    final targetPath = join(
      Build.outDir,
      target.name,
      '${Build.helperName}${target.executableExtensionName}',
    );
    await _replaceFile(File(outPath), targetPath);
  }

  static Future<void> _replaceFile(File source, String destinationPath) async {
    final staleFile = File('$destinationPath.old');
    if (staleFile.existsSync()) {
      try {
        staleFile.deleteSync();
      } catch (_) {}
    }

    try {
      await source.copy(destinationPath);
    } on PathExistsException catch (e) {
      if (!Platform.isWindows || !File(destinationPath).existsSync()) {
        rethrow;
      }
      print(
        'Cannot replace $destinationPath (${e.osError?.message ?? e.message}), '
        'renaming the running binary aside and retrying.',
      );
      await File(destinationPath).rename(staleFile.path);
      await source.copy(destinationPath);
    }

    File(destinationPath).setLastModifiedSync(DateTime.now());

    if (staleFile.existsSync()) {
      try {
        staleFile.deleteSync();
      } catch (_) {}
    }
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

  static const List<AssetDownloadItem> assetDownloadItems = [
    AssetDownloadItem(
      url:
          'https://github.com/appshubcc/bett-rules/releases/download/latest/geosite.dat',
      fileName: 'GeoSite.dat',
    ),
    AssetDownloadItem(
      url:
          'https://github.com/appshubcc/bett-rules/releases/download/latest/geoip.metadb',
      fileName: 'geoip.metadb',
    ),
    AssetDownloadItem(
      url:
          'https://github.com/appshubcc/bett-rules/releases/download/latest/GeoLite2-ASN-lite.mmdb',
      fileName: 'ASN.mmdb',
    ),
    AssetDownloadItem(
      url:
          'https://github.com/Zephyruso/zashboard/releases/download/v3.29.1/dist-no-fonts.zip',
      fileName: 'zash.zip',
    ),
  ];

  static Future<void> ensureAssets({bool force = false}) async {
    final dataDir = Directory(join(current, 'assets', 'data'));
    if (!dataDir.existsSync()) {
      dataDir.createSync(recursive: true);
    }

    final now = DateTime.now();
    final maxAge = const Duration(hours: 48);

    for (final item in assetDownloadItems) {
      final targetFile = File(join(dataDir.path, item.fileName));
      var shouldDownload = force;

      if (!shouldDownload) {
        if (!targetFile.existsSync() || targetFile.lengthSync() == 0) {
          shouldDownload = true;
        } else {
          final lastModified = targetFile.lastModifiedSync();
          final age = now.difference(lastModified);
          if (age >= maxAge) {
            shouldDownload = true;
          }
        }
      }

      if (shouldDownload) {
        print('Downloading ${item.fileName} from ${item.url} ...');
        await _downloadAsset(item.url, targetFile.path);
        print('Downloaded ${item.fileName} successfully.');
      } else {
        final ageHours = now.difference(targetFile.lastModifiedSync()).inHours;
        print('${item.fileName} is up to date (${ageHours}h < 48h).');
      }
    }
  }

  static Future<void> _downloadAsset(
    String url,
    String destinationPath, {
    int maxRetries = 3,
  }) async {
    final tempPath = '$destinationPath.tmp';
    final tempFile = File(tempPath);
    if (tempFile.existsSync()) {
      tempFile.deleteSync();
    }

    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);
      try {
        final request = await client.getUrl(Uri.parse(url));
        request.followRedirects = true;
        request.maxRedirects = 10;
        final response = await request.close();
        if (response.statusCode != HttpStatus.ok) {
          throw HttpException(
            'Failed with status ${response.statusCode}',
            uri: Uri.parse(url),
          );
        }
        final sink = tempFile.openWrite();
        await response.pipe(sink);
        await sink.flush();
        await sink.close();

        final destinationFile = File(destinationPath);
        if (destinationFile.existsSync()) {
          destinationFile.deleteSync();
        }
        tempFile.renameSync(destinationPath);
        File(destinationPath).setLastModifiedSync(DateTime.now());
        return;
      } catch (e) {
        if (tempFile.existsSync()) {
          try {
            tempFile.deleteSync();
          } catch (_) {}
        }
        if (attempt == maxRetries) {
          rethrow;
        }
        print('Download failed ($e), retrying ($attempt/$maxRetries)...');
        await Future.delayed(Duration(seconds: attempt * 2));
      } finally {
        client.close();
      }
    }
  }
}

class AssetDownloadItem {
  final String url;
  final String fileName;

  const AssetDownloadItem({required this.url, required this.fileName});
}

class BuildCommand extends Command {
  Target target;

  BuildCommand({required this.target}) {
    argParser.addOption(
      'arch',
      abbr: 'a',
      allowed: target == Target.android || target == Target.macos
          ? [...arches.map((e) => e.name), 'universal']
          : arches.map((e) => e.name),
      help: 'The architecture of $name build; omit this to select '
        '${target != Target.android ? "the host" : "every"} architecture',
    );
    if (target == Target.linux) {
      argParser.addMultiOption(
        'targets',
        abbr: 't',
        allowed: ['deb', 'rpm', 'appimage', 'zip'],
        help: 'Linux package formats, required for --out app (comma-separated)',
      );
    }
    argParser.addOption(
      'out',
      abbr: 'o',
      allowed: [
        if (target.buildable) 'app',
        'core',
        'core-only',
        'helper',
      ],
      help: 'app: package; core: core (+ Windows helper); '
          'core-only: core only; helper: helper only',
      defaultsTo: target.buildable ? 'app' : 'core',
    );
    argParser.addOption(
      'core-hash',
      help:
          'SHA256 hash of the (signed) core binary, used when --out=helper to embed the correct TOKEN',
    );
    argParser.addOption(
      'env',
      abbr: 'e',
      allowed: ['pre', 'stable'],
      help: 'The value of dart-define APP_ENV, used to identify the release channel',
      defaultsTo: 'pre',
    );
    argParser.addFlag(
      'compatible',
      abbr: 'C',
      help: 'Build with GOAMD64=v1 for broader compatibility on amd64',
    );
    argParser.addFlag('dev', help: 'Build debug/dev variant');
    argParser.addFlag(
      'ensure',
      help: 'Skip build if output artifact already exists',
    );
    argParser.addFlag(
      'build-only',
      abbr: 'B',
      help: 'Skip packaging the app with flutter_distributor',
    );
  }

  @override
  String get description => 'build $name application';

  @override
  String get name => target.name;

  List<Arch> get arches => Build.buildItems
      .where((element) => element.target == target)
      .map((e) => e.arch)
      .toList();

  Future<void> _setLinuxCoreSetuid() async {
    final coreFile = File('libclash/linux/BettboxCore');
    if (!coreFile.existsSync()) return;
    try {
      await Process.run('chmod', ['0755', coreFile.path]);
    } catch (_) {}
  }

  Future<void> _buildDistributor({
    required Target target,
    required String targets,
    String args = '',
    required String appEnv,
    required String suffix,
    final bool buildOnly = false,
  }) async {
    final sentryDsn = Platform.environment['SENTRY_DSN'] ?? '';
    String sentryArg = '';
    if (sentryDsn.isNotEmpty) {
      sentryArg = buildOnly
          ? ' --dart-define=SENTRY_DSN=$sentryDsn'
          : ' --build-dart-define=SENTRY_DSN=$sentryDsn';
    }
    String suffixArg = '';
    if (suffix.isNotEmpty) {
      suffixArg = buildOnly
          ? ' --dart-define=APP_ASSET_SUFFIX=$suffix'
          : ' --build-dart-define=APP_ASSET_SUFFIX=$suffix';
    }

    final ipinfoToken = Platform.environment['IPINFO_TOKEN'] ?? '';
    final ipinfoArg = ipinfoToken.isNotEmpty
        ? (buildOnly
              ? ' --dart-define=IPINFO_TOKEN=$ipinfoToken'
              : ' --build-dart-define=IPINFO_TOKEN=$ipinfoToken')
        : '';

    String appDevArg = '';
    if (Build.isDev) {
      appDevArg = buildOnly
          ? ' --dart-define=APP_DEV=true'
          : ' --build-dart-define=APP_DEV=true';
    }

    if (!buildOnly) await Build.getDistributor();
    await Build.exec(
      name: description,
      Build.getExecutable(
        buildOnly
            ? 'flutter build ${target == Target.android ? "apk" : target.name} --release --verbose$args$sentryArg$suffixArg$ipinfoArg --dart-define=APP_ENV=$appEnv$appDevArg'
            : 'flutter_distributor package --skip-clean --platform ${target.name} --targets $targets --flutter-build-args=verbose$args$sentryArg$suffixArg$ipinfoArg --build-dart-define=APP_ENV=$appEnv$appDevArg',
      ),
    );
  }

  List<String> _expectedOutputs(Arch? arch) {
    final items = Build.buildItems.where((element) {
      return element.target == target &&
          (arch == null ? true : element.arch == arch);
    });

    final outputs = <String>[];
    for (final item in items) {
      final outFileDir = join(Build.outDir, item.target.name, item.archName);
      if (target == Target.android) {
        outputs.add(join(outFileDir, '${Build.libName}.so'));
        outputs.add(join(outFileDir, '${Build.libName}.h'));
        continue;
      }

      outputs.add(
        join(outFileDir, '${Build.coreName}${target.executableExtensionName}'),
      );

      if (target == Target.windows) {
        outputs.add(
          join(
            outFileDir,
            '${Build.helperName}${target.executableExtensionName}',
          ),
        );
      }
    }
    return outputs;
  }

  DateTime _latestModified(Iterable<FileSystemEntity> entities) {
    var latest = DateTime.fromMillisecondsSinceEpoch(0);
    for (final entity in entities) {
      if (!entity.existsSync()) continue;
      final modified = entity.statSync().modified;
      if (modified.isAfter(latest)) latest = modified;
    }
    return latest;
  }

  DateTime _windowsSourcesLastModified() {
    final sources = <FileSystemEntity>[
      File(join(current, 'setup.dart')),
    ];

    final helperDir = Directory(Build._servicesDir);
    if (helperDir.existsSync()) {
      sources.addAll(helperDir.listSync(recursive: true).where((entity) {
        return entity is File &&
            !isWithin(join(Build._servicesDir, 'target'), entity.path);
      }));
    }

    final coreDir = Directory(Build._coreDir);
    if (coreDir.existsSync()) {
      sources.addAll(coreDir.listSync(recursive: true).whereType<File>());
    }

    return _latestModified(sources);
  }

  bool _outputsAreFresh(Arch? arch) {
    final outputs = _expectedOutputs(arch);
    if (outputs.isEmpty || !outputs.every((path) => File(path).existsSync())) {
      return false;
    }

    if (target == Target.windows) {
      final latestInput = _windowsSourcesLastModified();
      final oldestOutput = outputs
          .map((path) => File(path).statSync().modified)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      return !oldestOutput.isBefore(latestInput);
    }

    return true;
  }

  @override
  Future<void> run() async {
    await execute(
      archName: argResults?['arch'],
      out: argResults?['out'],
      appEnv: argResults?['env'] ?? 'pre',
      dev: argResults?['dev'] ?? false,
      ensure: argResults?['ensure'] ?? false,
      compatible: argResults?['compatible'] ?? false,
      buildOnly: argResults?['build-only'] ?? false,
      coreHash: argResults?['core-hash'] as String?,
    );
  }

  Future<void> execute({
    String? archName,
    String? out,
    String appEnv = 'pre',
    bool dev = false,
    bool ensure = false,
    bool compatible = false,
    bool buildOnly = false,
    String? coreHash,
  }) async {
    if (compatible && target != Target.windows && target != Target.linux) {
      throw '--compatible is only supported for windows and linux';
    }

    // TODO: implement macOS universal builds once PR #226's lipo approach is
    // fixed; the current code would only produce a single-arch core.
    if (archName == 'universal' && target == Target.macos) {
      throw UsageException(
        '--arch universal is not currently implemented',
        argParser.usage,
      );
    }

    final coreMode = target == Target.android ? CoreMode.lib : CoreMode.core;
    final String actualOut = out ?? (target.buildable ? 'app' : 'core');
    Build.isDev = dev;

    await Build.ensureAssets();

    final String? archParam = archName;

    Arch? arch;
    if (archParam == null) {
      if (target != Target.android) {
        arch = arches.firstWhereOrNull((element) => element.same);
        if (arch == null) {
          throw 'Unsupported host architecture '
              '(supported: ${arches.map((e) => e.name).join(', ')})';
        }
      }
    } else if (archParam == 'universal') {
      if (target != Target.android && target != Target.macos) {
        throw 'Invalid arch parameter!';
      }
    } else {
      arch = arches.where((element) => element.name == archParam).firstOrNull;
      if (arch == null) throw 'Invalid arch parameter!';
    }

    if (compatible && arch != Arch.amd64) {
      throw '--compatible is only supported on amd64';
    }

    if (target == Target.android && buildOnly) {
      print('--build-only is ignored on android; the APK is always packaged.');
      buildOnly = false;
    }

    if (ensure && actualOut != 'app') {
      if (_outputsAreFresh(arch)) {
        print('${target.name} output already exists');
        return;
      }
    }

    final corePaths = await Build.buildCore(
      target: target,
      arch: arch,
      mode: coreMode,
      compatible: compatible,
    );

    if (actualOut == 'core-only') {
      return;
    }

    if (actualOut == 'helper') {
      if (target != Target.windows) {
        throw '--out helper is only supported for windows';
      }
      if (coreHash == null || coreHash.isEmpty) {
        throw '--core-hash is required when --out=helper';
      }
      await Build.buildHelper(target, coreHash);
      return;
    }

    if (actualOut == 'app' && !target.buildable) {
      print('Platform incompatible, core built only!');
      return;
    }

    if (actualOut != 'app') {
      if (target == Target.windows) {
        final token = await Build.calcSha256(corePaths.first);
        await Build.buildHelper(target, token);
      }
      return;
    }

    final String desc = target == Target.android
        ? ''
        : '${archParam ?? arch!.name}${compatible ? "-compatible" : ""}';

    String appAssetSuffix = '';
    switch (target) {
      case Target.windows:
        appAssetSuffix = 'windows-$desc-setup.exe';
        break;
      case Target.macos:
        appAssetSuffix = 'macos-$desc.dmg';
        break;
      case Target.linux:
        break;
      case Target.android:
        if (archParam == 'universal') {
          appAssetSuffix = 'android-universal.apk';
        } else if (arch == Arch.arm64) {
          appAssetSuffix = 'android-arm64-v8a.apk';
        } else if (arch == Arch.arm) {
          appAssetSuffix = 'android-armeabi-v7a.apk';
        } else if (arch == Arch.amd64) {
          appAssetSuffix = 'android-x86_64.apk';
        }
        break;
    }

    switch (target) {
      case Target.windows:
        if (!arch!.same) {
          throw 'Cross-build to $name ${arch.name} target is not currently supported!';
        }

        final token = target != Target.android
            ? await Build.calcSha256(corePaths.first)
            : null;
        await checkDeps(commands: ['cargo']);
        await Build.buildHelper(target, token!);
        await checkDeps(
          commands: ['rustup'],
          files: buildOnly ? null : [r'C:\Program Files (x86)\Inno Setup 6\ISCC.exe'],
        );
        await _buildDistributor(
          target: target,
          targets: 'exe',
          args: buildOnly
              ? ' --dart-define=CORE_SHA256=$token'
              : ' --description $desc --build-dart-define=CORE_SHA256=$token',
          appEnv: appEnv,
          suffix: appAssetSuffix,
          buildOnly: buildOnly,
        );
        return;
      case Target.linux:
        if (!arch!.same) {
          throw 'Cross-build to $name ${arch.name} target is not currently supported!';
        }

        final validTargets = ['deb', 'rpm', 'appimage', 'zip'];
        final targets = argResults?['targets'] ?? <String>[];
        if (!buildOnly) {
          if (targets.isEmpty) {
            throw 'Linux app packaging requires '
                '--targets (deb, rpm, appimage, zip)';
          }
          final invalidTargets = targets.where((t) => !validTargets.contains(t)).toList();
          if (invalidTargets.isNotEmpty) {
            throw 'Unsupported --targets value(s): '
                '${invalidTargets.join(', ')} '
                '(expected deb, rpm, appimage, zip)';
          }
        }

        final requiredCmds = ['clang', 'cmake', 'ninja', 'rustup'];
        Map<String, String> requiredRtLibs = {};
        if (targets.contains('deb')) requiredCmds.add('dpkg-deb');
        if (targets.contains('rpm')) requiredCmds.addAll(['rpm', 'patchelf']);
        if (targets.contains('appimage')) {
          requiredCmds.addAll(['appimagetool', 'locate']);
          requiredRtLibs.addAll({'libfuse2': 'libfuse.so.2'});
        }
        await checkDeps(
          commands: requiredCmds,
          devLibs: {
            'gtk3': 'gtk+-3.0',
            'libayatana-appindicator': 'ayatana-appindicator3-0.1',
            'keybinder-3.0': 'keybinder-3.0',
            'libcurl': 'libcurl',
          },
          rtLibs: requiredRtLibs,
        );

        final targetMap = {Arch.arm64: 'linux-arm64', Arch.amd64: 'linux-x64'};
        final defaultTarget = targetMap[arch];

        await _setLinuxCoreSetuid();

        for (final t in targets.isEmpty ? [''] : targets) {
          final ext = t == 'appimage' ? 'AppImage' : t;
          final currentSuffix = 'linux-$desc.$ext';

          await _buildDistributor(
            target: target,
            targets: t,
            args: buildOnly
                ? ' --target-platform $defaultTarget'
                : ' --description $desc --build-target-platform $defaultTarget',
            appEnv: appEnv,
            suffix: currentSuffix,
            buildOnly: buildOnly,
          );
        }
        return;
      case Target.android:
        await checkDeps(commands: ['rustup']);
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

        await _buildDistributor(
          target: target,
          targets: 'apk',
          args: buildArgs,
          appEnv: appEnv,
          suffix: appAssetSuffix,
        );
        return;
      case Target.macos:
        await checkDeps(commands: ['rustup']);
        if (!buildOnly) await checkDeps(commands: ['appdmg']);
        await Build.exec(
          Build.getExecutable('rm -rf Pods Podfile.lock'),
          workingDirectory: 'macos',
        );
        await Build.exec(Build.getExecutable('flutter pub get'));
        await Build.exec(
          Build.getExecutable('pod install --repo-update'),
          workingDirectory: 'macos',
        );
        final infoPlist = File('macos/Runner/Info.plist');
        final infoPlistContent = await infoPlist.readAsString();
        if (arch == Arch.amd64) {
          await infoPlist.writeAsString(
            infoPlistContent.replaceFirst(
              '</dict>\n</plist>',
              '\t<key>FLTEnableImpeller</key>\n\t<false/>\n</dict>\n</plist>',
            ),
          );
        }
        try {
          await _buildDistributor(
            target: target,
            targets: 'dmg',
            args: buildOnly ? '' : ' --description $desc',
            appEnv: appEnv,
            suffix: appAssetSuffix,
            buildOnly: buildOnly,
          );
        } finally {
          await infoPlist.writeAsString(infoPlistContent);
        }
        return;
    }
  }
}

class AutoBuildCommand extends Command {
  AutoBuildCommand() {
    argParser.addOption(
      'device-id',
      help: 'Target Flutter device ID (e.g. from \${command:flutter.getSelectedDeviceId})',
    );
    argParser.addOption(
      'arch',
      help: 'Target architecture (default: auto detect based on device)',
    );
    argParser.addOption(
      'out',
      allowed: ['core', 'core-only'],
      defaultsTo: 'core',
      help: 'Build output type; auto only builds the core. '
          'Package with: dart setup.dart <platform> --out app',
    );
    argParser.addFlag(
      'compatible',
      help: 'Build with GOAMD64=v1 for broader compatibility on amd64',
    );
    argParser.addFlag('dev', help: 'Build debug/dev variant');
    argParser.addFlag(
      'ensure',
      help: 'Skip build if output artifact already exists',
    );
  }

  @override
  String get description => 'Automatically detect target device and build core';

  @override
  String get name => 'auto';

  @override
  Future<void> run() async {
    final optDeviceId = argResults?['device-id']?.toString().trim() ?? '';
    final rawDeviceId = optDeviceId.startsWith('-') ? '' : optDeviceId;
    final String? explicitArch = argResults?['arch'];

    Target? target;
    String? archName = explicitArch;

    if (rawDeviceId == 'windows') {
      target = Target.windows;
    } else if (rawDeviceId == 'macos') {
      target = Target.macos;
    } else if (rawDeviceId == 'linux') {
      target = Target.linux;
    } else if (rawDeviceId == 'chrome' ||
        rawDeviceId == 'edge' ||
        rawDeviceId == 'web-server') {
      print('Web device "$rawDeviceId" does not require core binary. Skipping.');
      return;
    } else if (rawDeviceId.isEmpty) {
      if (Platform.isWindows) {
        target = Target.windows;
      } else if (Platform.isMacOS) {
        target = Target.macos;
      } else if (Platform.isLinux) {
        target = Target.linux;
      } else {
        throw 'No device specified and unable to determine host platform.';
      }
    } else {
      final res = await Process.run(
        'flutter',
        ['devices', '--machine'],
        runInShell: true,
      );
      if (res.exitCode != 0) {
        throw 'Failed to execute "flutter devices --machine": ${res.stderr}';
      }
      final jsonList = jsonDecode(res.stdout.toString()) as List<dynamic>;
      final device = jsonList.cast<Map<String, dynamic>?>().firstWhere(
            (d) => d?['id'] == rawDeviceId,
            orElse: () => null,
          );

      if (device == null) {
        throw 'Device "$rawDeviceId" not found in flutter devices list.';
      }

      final targetPlatform =
          (device['targetPlatform'] as String? ?? '').toLowerCase();
      if (targetPlatform.startsWith('android')) {
        target = Target.android;
        if (archName == null) {
          if (targetPlatform.contains('arm64')) {
            archName = 'arm64';
          } else if (targetPlatform.contains('x64') ||
              targetPlatform.contains('x86_64')) {
            archName = 'amd64';
          } else if (targetPlatform.contains('arm')) {
            archName = 'arm';
          } else {
            throw 'Unsupported android platform architecture: $targetPlatform';
          }
        }
      } else if (targetPlatform.startsWith('darwin') ||
          targetPlatform.startsWith('macos')) {
        target = Target.macos;
      } else if (targetPlatform.startsWith('windows')) {
        target = Target.windows;
      } else if (targetPlatform.startsWith('linux')) {
        target = Target.linux;
      } else if (targetPlatform.startsWith('web')) {
        print(
          'Web target platform "$targetPlatform" does not require core binary. Skipping.',
        );
        return;
      } else {
        throw 'Unknown or unsupported targetPlatform: $targetPlatform';
      }
    }

    final cmd = BuildCommand(target: target);
    await cmd.execute(
      archName: archName,
      out: argResults?['out'] ?? 'core',
      dev: argResults?['dev'] ?? false,
      ensure: argResults?['ensure'] ?? false,
      compatible: argResults?['compatible'] ?? false,
    );
  }
}

class AssetsCommand extends Command {
  AssetsCommand() {
    argParser.addFlag(
      'force',
      abbr: 'f',
      help: 'Force download assets even if within 48 hours',
    );
  }

  @override
  String get description => 'Download or update assets if older than 48 hours';

  @override
  String get name => 'assets';

  @override
  Future<void> run() async {
    final force = argResults?['force'] as bool? ?? false;
    await Build.ensureAssets(force: force);
  }
}

Future<void> main(Iterable<String> args) async {
  final runner = CommandRunner('setup', 'build Application');
  runner.addCommand(AutoBuildCommand());
  runner.addCommand(AssetsCommand());
  runner.addCommand(BuildCommand(target: Target.android));
  runner.addCommand(BuildCommand(target: Target.linux));
  runner.addCommand(BuildCommand(target: Target.windows));
  runner.addCommand(BuildCommand(target: Target.macos));
  try {
    await runner.run(args);
  } on UsageException catch (e) {
    print(e.message);
    print(e.usage);
    exitCode = 64;
  }
}
