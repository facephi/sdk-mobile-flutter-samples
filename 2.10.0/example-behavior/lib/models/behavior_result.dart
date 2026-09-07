import 'dart:core';
import 'package:widget_behavior_flutter/widget_behavior_finish_status.dart';

class BehaviorResult
{
  final WidgetBehaviorFinishStatus finishStatus;
  final String finishStatusDescription;
  final String errorType;
  final String? errorMessage;
  final dynamic data;
  
  const BehaviorResult({
    required this.finishStatus,
    required this.finishStatusDescription,
    required this.errorType,
    required this.errorMessage,
    required this.data
  });

  Map<String, dynamic> toMap() {
    return {
      'finishStatus': finishStatus.toInt(),
      'finishStatusDescription': finishStatusDescription,
      'errorType': errorType,
      'errorMessage': errorMessage ?? "",
      'data': data ?? ""
    };
  }

  static BehaviorResult fromMap(Map<dynamic, dynamic> map) {
    return BehaviorResult(
        finishStatus: WidgetBehaviorFinishStatus.getEnum(map['finishStatus']),
        finishStatusDescription: map['finishStatusDescription'],
        errorType: map['errorType'] ?? "",
        errorMessage: map['errorMessage'] ?? "",
        data: map['data'] ?? ""
    );
  }
}