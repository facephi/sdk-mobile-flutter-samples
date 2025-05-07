import 'dart:core';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';
//import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';

class PhingersResult
{
  final SdkFinishStatus finishStatus;
  final String finishStatusDescription;
  final String errorDiagnostic;
  final String? errorMessage;
  final dynamic fingers;
  final dynamic slapImages;

  const PhingersResult({
    required this.finishStatus,
    required this.finishStatusDescription,
    required this.errorDiagnostic,
    required this.errorMessage,
    required this.fingers,
    required this.slapImages,
  });

  Map<String, dynamic> toMap() {
    return {
      'finishStatus': finishStatus.toInt(),
      'finishStatusDescription': finishStatusDescription,
      'errorDiagnostic': errorDiagnostic,
      'errorMessage': errorMessage ?? "",
      'fingers': fingers,
      'slapImages': slapImages,
    };
  }

  static PhingersResult fromMap(Map<dynamic, dynamic> map) {
    return PhingersResult(
      finishStatus: SdkFinishStatus.getEnum(map['finishStatus']),
      finishStatusDescription: map['finishStatusDescription'],
      errorDiagnostic: map['errorDiagnostic'] ?? "",
      errorMessage: map['errorMessage'] ?? "",
      fingers: map['fingers'] ?? "",
      slapImages: map['slapImages'] ?? "",
    );
  }

  @override
  String toString() {
    return 'PhingersResult(finishStatus: $finishStatus, errorDiagnostic: $errorDiagnostic, errorMessage: $errorMessage, finishStatusDescription: $finishStatusDescription)';
  }
}