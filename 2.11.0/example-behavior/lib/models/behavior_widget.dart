import 'dart:io' show Platform;

import 'package:example/license.dart';
import 'package:widget_behavior_flutter/widget_behavior.dart';
import 'package:widget_behavior_flutter/widget_behavior_configuration.dart';
import 'package:widget_behavior_flutter/widget_behavior_event.dart';

/// Calls the Behavior Plugin and returns the native result to the UI.
class BehaviorWidget {
  Future initialize() async {
    final cfg = WidgetBehaviorConfiguration();
    cfg.licenseKey = Platform.isAndroid ? licenseKeyAndroid : licenseKeyIOS;
    cfg.enableSupportLogs = true;

    return WidgetBehavior().initialize(widgetConfigurationJSON: cfg);
  }

  Future setPosition(String position) async {
    return WidgetBehavior().setPosition(position: position);
  }

  Future setSessionId(String sessionId) async {
    return WidgetBehavior().setSessionId(sessionId: sessionId);
  }

  Future setUserId(String userId) async {
    return WidgetBehavior().setUserId(userId: userId);
  }

  Future clearSessionData() async {
    return WidgetBehavior().clearSessionData();
  }

  Future handleTypingEvent(BehaviorEvent event) async {
    return WidgetBehavior().handleTypingEvent(event: event);
  }
}
