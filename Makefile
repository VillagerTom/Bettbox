android_arm64:
	dart ./setup.dart android --arch arm64
macos_arm64:
	dart ./setup.dart macos --arch arm64
android_app:
	dart ./setup.dart android
android_arm64_core:
	dart ./setup.dart android --arch arm64 --out core
macos_arm64_core:
	dart ./setup.dart macos --arch arm64  --out core

windows_core_and_helper:
	dart ./setup.dart windows --out core,helper
	
windows_core_and_helper_amd64_compatible:
	dart ./setup.dart windows --out core,helper --arch amd64 --compatible

windows_app:
	dart ./setup.dart windows
	
windows_app_amd64_compatible:
	dart ./setup.dart windows --arch amd64 --compatible
