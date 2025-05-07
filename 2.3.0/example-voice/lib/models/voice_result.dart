import 'dart:core';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';

class VoiceResult {
  final SdkFinishStatus finishStatus;
  final String finishStatusDescription;
  final String errorDiagnostic;
  final String? errorMessage;
  final String? data;
  final String? audios;
  final String? tokenizedAudios;
  
  const VoiceResult({
    required this.finishStatus,
    required this.finishStatusDescription,
    required this.errorDiagnostic,
    required this.errorMessage,
    required this.data,
    required this.audios,
    required this.tokenizedAudios
  });

  Map<String, dynamic> toMap() {
    return {
      'finishStatus': finishStatus.toInt(),
      'finishStatusDescription': finishStatusDescription,
      'errorDiagnostic': errorDiagnostic,
      'errorMessage': errorMessage ?? '',
      'data': data ?? '',
      'audios': audios ?? '',
      'tokenizedAudios': tokenizedAudios ?? '',
    };
  }

  static VoiceResult fromMap(Map<dynamic, dynamic> map)
  {
    return VoiceResult(
      finishStatus: SdkFinishStatus.getEnum(map['finishStatus']),
      finishStatusDescription: map['finishStatusDescription'] ?? "",
      errorDiagnostic: map['errorDiagnostic'] ?? "",
      errorMessage: map['errorMessage'] ?? "",
      data: map['data'] ?? "",
      audios: map['audios'] ?? "",
      tokenizedAudios: map['tokenizedAudios'] ?? "",
    );
  }

  @override
  String toString() {
    return 'VoiceResult(finishStatus: $finishStatus, finishStatusDescription: $finishStatusDescription, errorDiagnostic: $errorDiagnostic, errorMessage: $errorMessage, data: $data, audios: $audios, tokenizedAudios: $tokenizedAudios)';
  }
}