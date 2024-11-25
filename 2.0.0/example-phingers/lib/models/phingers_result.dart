import 'dart:core';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';
//import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';

class PhingersResult
{
  final SdkFinishStatus finishStatus;
  final String finishStatusDescription;
  final String errorDiagnostic;
  final String? errorMessage;
  final String? fullFrameImage;
  final dynamic focusQuality;
  final dynamic livenessConfidence;
  final dynamic processedFingers;
  final dynamic rawImages;
  final dynamic wsq;

  const PhingersResult({
    required this.finishStatus,
    required this.finishStatusDescription,
    required this.errorDiagnostic,
    required this.errorMessage,
    required this.fullFrameImage,
    required this.focusQuality,
    required this.livenessConfidence,
    required this.processedFingers,
    required this.rawImages,
    required this.wsq,
  });

  Map<String, dynamic> toMap() {
    return {
      'finishStatus': finishStatus.toInt(),
      'finishStatusDescription': finishStatusDescription,
      'errorDiagnostic': errorDiagnostic,
      'errorMessage': errorMessage ?? "",
      'fullFrameImage': fullFrameImage,
      'focusQuality': focusQuality,
      'livenessConfidence': livenessConfidence,
      'processedFingers': processedFingers,
      'rawImages': rawImages,
      'wsq': wsq,
    };
  }

  static PhingersResult fromMap(Map<dynamic, dynamic> map) {
    return PhingersResult(
      finishStatus: SdkFinishStatus.getEnum(map['finishStatus']),
      finishStatusDescription: map['finishStatusDescription'],
      errorDiagnostic: map['errorDiagnostic'] ?? "",
      errorMessage: map['errorMessage'] ?? "",
      fullFrameImage: map['fullFrameImage'] ?? "",
      focusQuality: map['focusQuality'] ?? "",
      livenessConfidence: map['livenessConfidence'] ?? "",
      processedFingers: map['processedFingers'] ?? "",
      rawImages: map['rawImages'] ?? "",
      wsq: map['wsq'] ?? "",
    );
  }

  @override
  String toString() {
    return 'PhingersResult(finishStatus: $finishStatus, errorDiagnostic: $errorDiagnostic, errorMessage: $errorMessage, finishStatusDescription: $finishStatusDescription, fullFrameImage: $fullFrameImage)';
  }
}