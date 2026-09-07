import 'dart:convert';

import 'package:example/api/fip360_service.dart';
import 'package:example/models/behavior_result.dart';
import 'package:example/models/behavior_widget.dart';
import 'package:example/services/behavior_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:widget_behavior_flutter/widget_behavior_event.dart';
import 'package:widget_behavior_flutter/widget_behavior_finish_status.dart';

typedef ErrorCallback = void Function(String message);

BehaviorResult _parseResult(dynamic res) {
  if (res is Map) {
    return BehaviorResult.fromMap(Map<dynamic, dynamic>.from(res));
  }
  throw StateError('Unexpected behavior result: $res');
}

String _errorFromResult(BehaviorResult result) {
  if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
    return result.errorMessage!;
  }
  if (result.errorType.isNotEmpty) {
    return result.errorType;
  }
  return 'Unknown error';
}

Future<bool> launchInitialize({ErrorCallback? onError}) async {
  if (kDebugMode) {
    print('Starting launchInitialize...');
  }

  try {
    final res = await BehaviorWidget().initialize();
    final BehaviorResult result = _parseResult(res);
    if (kDebugMode) {
      print(result.toMap());
    }

    if (result.finishStatus == WidgetBehaviorFinishStatus.statusOk) {
      final sessionOk = await launchSetSessionId(onError: onError);
      if (!sessionOk) {
        return false;
      }
      await launchSetPosition('Login', onError: onError);
      return true;
    }

    if (result.finishStatus == WidgetBehaviorFinishStatus.statusError) {
      onError?.call(_errorFromResult(result));
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error initialize: $error');
    }
    onError?.call(error.toString());
  } finally {
    launchListenerBehaviorEvents();
    if (kDebugMode) {
      print('End initialize...');
    }
  }

  return false;
}

Future<bool> launchSetSessionId({ErrorCallback? onError}) async {
  if (kDebugMode) {
    print('Starting launchSetSessionId...');
  }

  final String sessionId = await Fip360Service().getSessionId();

  try {
    final res = await BehaviorWidget().setSessionId(sessionId);
    final BehaviorResult result = _parseResult(res);
    if (kDebugMode) {
      print(result.toMap());
    }

    if (result.finishStatus == WidgetBehaviorFinishStatus.statusOk) {
      BehaviorService.instance.sessionId = sessionId;
      return true;
    }

    if (result.finishStatus == WidgetBehaviorFinishStatus.statusError) {
      onError?.call(_errorFromResult(result));
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error setSessionId: $error');
    }
    onError?.call(error.toString());
  } finally {
    if (kDebugMode) {
      print('End setSessionId...');
    }
  }

  return false;
}

Future<bool> launchSetUserId(String userId, {ErrorCallback? onError}) async {
  if (kDebugMode) {
    print('Starting launchSetUserId...');
  }

  try {
    final res = await BehaviorWidget().setUserId(userId);
    final BehaviorResult result = _parseResult(res);
    if (kDebugMode) {
      print(result.toMap());
    }

    if (result.finishStatus == WidgetBehaviorFinishStatus.statusOk) {
      BehaviorService.instance.userId = userId;
      return true;
    }

    if (result.finishStatus == WidgetBehaviorFinishStatus.statusError) {
      onError?.call(_errorFromResult(result));
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error setUserId: $error');
    }
    onError?.call(error.toString());
  } finally {
    if (kDebugMode) {
      print('End setUserId...');
    }
  }

  return false;
}

Future<bool> launchSetPosition(String position, {ErrorCallback? onError}) async {
  if (kDebugMode) {
    print('Starting launchSetPosition...');
  }

  try {
    final res = await BehaviorWidget().setPosition(position);
    final BehaviorResult result = _parseResult(res);
    if (kDebugMode) {
      print(result.toMap());
    }

    if (result.finishStatus == WidgetBehaviorFinishStatus.statusError) {
      onError?.call(_errorFromResult(result));
      return false;
    }

    return true;
  } catch (error) {
    if (kDebugMode) {
      print('Error setPosition: $error');
    }
    onError?.call(error.toString());
  } finally {
    if (kDebugMode) {
      print('End setPosition...');
    }
  }

  return false;
}

Future<void> launchClearSession({ErrorCallback? onError}) async {
  if (kDebugMode) {
    print('Starting launchClearSession...');
  }

  try {
    final res = await BehaviorWidget().clearSessionData();
    final BehaviorResult result = _parseResult(res);
    if (kDebugMode) {
      print(result.toMap());
    }
    BehaviorService.instance.sessionId = '';
  } catch (error) {
    if (kDebugMode) {
      print('Error launchClearSession: $error');
    }
    onError?.call(error.toString());
  } finally {
    if (kDebugMode) {
      print('End launchClearSession...');
    }
  }
}

Future<void> launchRegisterField({
  required String value,
  required String fieldType,
  String inputType = 'insertText',
}) async {
  try {
    final event = BehaviorEvent(v: value, f: fieldType, t: inputType);
    await BehaviorWidget().handleTypingEvent(event);
  } catch (error) {
    if (kDebugMode) {
      print('Error registerField: $error');
    }
  }
}

void launchListenerBehaviorEvents() async
{
  const channel = BasicMessageChannel<dynamic>('behavior.events.listener', StringCodec());
  channel.setMessageHandler((message) async
  {
    if (kDebugMode) {
      print('WIDGET_BEHAVIOR_EVENTS: ${jsonDecode(message!)}');
    }
    return '';
  });
}
