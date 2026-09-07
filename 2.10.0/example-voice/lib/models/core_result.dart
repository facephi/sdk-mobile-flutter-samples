import 'dart:core';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';
//import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';

class CoreResult
{
  final SdkFinishStatus finishStatus;
  final String finishStatusDescription;
  final String errorDiagnostic;
  final String? errorMessage;
  final String? data;
  
  const CoreResult({
    required this.finishStatus,
    required this.finishStatusDescription,
    required this.errorDiagnostic,
    required this.errorMessage,
    required this.data
  });

  Map<String, dynamic> toMap() {
    return {
      'finishStatus': finishStatus.toInt(),
      'finishStatusDescription': finishStatusDescription,
      'errorDiagnostic': errorDiagnostic,
      'errorMessage': errorMessage ?? "",
      'data': data ?? ""
    };
  }

  static CoreResult fromMap(Map<dynamic, dynamic> map) {
    return CoreResult(
        finishStatus: SdkFinishStatus.getEnum(map['finishStatus']),
        finishStatusDescription: map['finishStatusDescription'],
        errorDiagnostic: map['errorDiagnostic'] ?? "",
        errorMessage: map['errorMessage'] ?? "",
        data: map['data'] ?? ""
    );
  }

  @override
  String toString() {
    return 'CoreResult(finishStatus: $finishStatus, finishStatusDescription: $finishStatusDescription, errorDiagnostic: $errorDiagnostic, errorMessage: $errorMessage, data: $data)';
  }
}