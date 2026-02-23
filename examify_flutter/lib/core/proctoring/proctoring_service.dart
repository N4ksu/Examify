import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:window_manager/window_manager.dart';

enum ProctoringAction { warn, finalWarn, autoSubmitted }

class ProctoringService with WidgetsBindingObserver, WindowListener {
  final int attemptId;
  final Dio apiClient;
  int violationCount = 0;
  Function(ProctoringAction)? onViolation;

  bool _isProctoring = false;

  ProctoringService({
    required this.attemptId,
    required this.apiClient,
    this.onViolation,
  });

  Future<void> start() async {
    if (_isProctoring) return;
    _isProctoring = true;

    WidgetsBinding.instance.addObserver(this);

    if (Platform.isAndroid) {
      await _lockAndroid();
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      await _lockDesktop();
    }
  }

  Future<void> stop() async {
    if (!_isProctoring) return;
    _isProctoring = false;

    WidgetsBinding.instance.removeObserver(this);

    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      windowManager.removeListener(this);
      await windowManager.setFullScreen(false);
      await windowManager.setAlwaysOnTop(false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _reportViolation('app_background');
    }
  }

  @override
  void onWindowFocus() {
    // Window gained focus
  }

  @override
  void onWindowBlur() {
    // Window lost focus on desktop
    _reportViolation('window_blur');
  }

  Future<void> _lockAndroid() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> _lockDesktop() async {
    // Ensure window manager is initialized (it should be initialized in main.dart)
    windowManager.addListener(this);
    await windowManager.setFullScreen(true);
    await windowManager.setAlwaysOnTop(true);
  }

  Future<String> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return '${info.manufacturer} ${info.model} (API ${info.version.sdkInt})';
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return '${info.name} ${info.systemVersion}';
    } else if (Platform.isWindows) {
      final info = await deviceInfo.windowsInfo;
      return 'Windows ${info.majorVersion}.${info.minorVersion}';
    } else if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      return 'macOS ${info.osRelease}';
    } else if (Platform.isLinux) {
      final info = await deviceInfo.linuxInfo;
      return '${info.name} ${info.version}';
    }
    return 'Unknown Device';
  }

  String _getPlatformName() {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Web/Unknown';
  }

  Future<void> _reportViolation(String eventType) async {
    violationCount++;
    final info = await _getDeviceInfo();

    try {
      final response = await apiClient.post(
        '/attempts/$attemptId/proctor-event',
        data: {
          'event_type': eventType,
          'platform': _getPlatformName(),
          'device_info': info,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
      );

      final action = response.data['action'];
      if (action == 'warn') onViolation?.call(ProctoringAction.warn);
      if (action == 'final_warn') onViolation?.call(ProctoringAction.finalWarn);
      if (action == 'auto_submitted') {
        onViolation?.call(ProctoringAction.autoSubmitted);
      }
    } catch (e) {
      debugPrint('Failed to report violation: $e');
    }
  }
}
