import 'dart:html' as html;
import 'proctoring_platform.dart';

class WebProctoring extends ProctoringPlatform {
  @override
  void lockWeb(Function(String) onViolation) {
    html.document.documentElement?.requestFullscreen();
    html.window.onBlur.listen((event) {
      onViolation('web_tab_switch');
    });
  }

  @override
  void unlockWeb() {
    html.document.exitFullscreen();
  }

  @override
  String getUserAgent() {
    return html.window.navigator.userAgent;
  }
}

ProctoringPlatform getPlatform() => WebProctoring();
