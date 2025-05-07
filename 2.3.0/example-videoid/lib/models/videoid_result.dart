import 'dart:core';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';

class VideoIdResult {
  final SdkFinishStatus finishStatus;
  final String finishStatusDescription;
  final String errorDiagnostic;
  final String? errorMessage;
  final dynamic ocrMap;
  final String? faceImage;
  final double? matchingSidesScore;
  final String? speechText;
  final dynamic personalData;
  final dynamic frontDocumentData;
  final dynamic backDocumentData;

  const VideoIdResult({
    required this.finishStatus,
    required this.finishStatusDescription,
    required this.errorDiagnostic,
    required this.errorMessage,
    required this.ocrMap,
    required this.faceImage,
    required this.matchingSidesScore,
    required this.speechText,
    required this.personalData,
    required this.backDocumentData,
    required this.frontDocumentData
  });

  Map<String, dynamic> toMap() {
    return {
      'finishStatus': finishStatus.toInt(),
      'finishStatusDescription': finishStatusDescription,
      'errorDiagnostic': errorDiagnostic,
      'errorMessage': errorMessage,
      'ocrMap': ocrMap,
      'faceImage': faceImage,
      'matchingSidesScore': matchingSidesScore,
      'speechText': speechText,
      'personalData': personalData,
      'backDocumentData': backDocumentData,
      'frontDocumentData': frontDocumentData
    };
  }

  static VideoIdResult fromMap(Map<dynamic, dynamic> map)
  {
    return VideoIdResult(
      finishStatus: SdkFinishStatus.getEnum(map['finishStatus']),
      finishStatusDescription: map['finishStatusDescription'] ?? "",
      errorDiagnostic: map['errorDiagnostic'] ?? "",
      errorMessage: map['errorMessage'] ?? "",
      ocrMap: map['ocrMap'] ?? "",
      faceImage: map['faceImage'] ?? "",
      matchingSidesScore: map['matchingSidesScore'] ?? "",
      speechText: map['speechText'] ?? "",
      personalData: map['personalData'] ?? "",
      backDocumentData: map['backDocumentData'] ?? "",
      frontDocumentData: map['frontDocumentData'] ?? "",
    );
  }

  @override
  String toString() {
    return 'VideoCallResult(finishStatus: $finishStatus, finishStatusDescription: $finishStatusDescription, errorDiagnostic: $errorDiagnostic, errorMessage: $errorMessage, ocrMap: $ocrMap)';
  }
}