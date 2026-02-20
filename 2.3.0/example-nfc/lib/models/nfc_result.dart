import 'dart:core';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';

class NfcResult
{
  final SdkFinishStatus finishStatus;
  final String finishStatusDescription;
  final String errorDiagnostic;
  final String? errorMessage;
  final int timeoutStatus;
  final String? facialImage;
  final String? signatureImage;
  final String tokenFacialImage;
  final String tokenSignatureImage;
  final String tokenOCR;
  final dynamic nfcDocumentInformation;
  final dynamic nfcRawData;
  final dynamic nfcSecurityData;
  final dynamic nfcValidations;
  final dynamic nfcPersonalInformation;

  const NfcResult({
    required this.finishStatus,
    required this.finishStatusDescription,
    required this.errorDiagnostic,
    required this.errorMessage,
    required this.timeoutStatus,
    required this.tokenOCR,
    required this.facialImage,
    required this.signatureImage,
    required this.tokenFacialImage,
    required this.tokenSignatureImage,
    required this.nfcDocumentInformation,
    required this.nfcRawData,
    required this.nfcPersonalInformation,
    required this.nfcSecurityData,
    required this.nfcValidations,
  });

  Map<String, dynamic> toMap() {
    return {
      'finishStatus': finishStatus.toInt(),
      'finishStatusDescription': finishStatusDescription,
      'errorDiagnostic': errorDiagnostic,
      'errorMessage': errorMessage ?? "",
      'timeoutStatus': timeoutStatus,
      'tokenOCR': tokenOCR,
      'facialImage': facialImage,
      'signatureImage': signatureImage,
      'tokenFacialImage': tokenFacialImage,
      'tokenSignatureImage': tokenSignatureImage,
      'nfcDocumentInformation': nfcDocumentInformation,
      'nfcRawData': nfcRawData,
      'nfcPersonalInformation': nfcPersonalInformation,
      'nfcSecurityData': nfcSecurityData,
      'nfcValidations': nfcValidations,
    };
  }

  static NfcResult fromMap(Map<dynamic, dynamic> map) {
    return NfcResult(
      finishStatus: SdkFinishStatus.getEnum(map['finishStatus']),
      finishStatusDescription: map['finishStatusDescription'],
      errorDiagnostic: map['errorDiagnostic'] ?? "",
      errorMessage: map['errorMessage'] ?? "",
      timeoutStatus: map['timeoutStatus'] ?? 0,
      tokenOCR: map['tokenOCR'] ?? "",
      facialImage: map['facialImage'] ?? "",
      signatureImage: map['signatureImage'] ?? "",
      tokenFacialImage: map['tokenFacialImage'] ?? "",
      tokenSignatureImage: map['tokenSignatureImage'] ?? "",
      nfcDocumentInformation: map['nfcDocumentInformation'] ?? "",
      nfcRawData: map['nfcRawData'] ?? "",
      nfcPersonalInformation: map['nfcPersonalInformation'] ?? "",
      nfcSecurityData: map['nfcSecurityData'] ?? "",
      nfcValidations: map['nfcValidations'] ?? "",
    );
  }

  @override
  String toString() {
    return 'NfcResult(finishStatus: $finishStatus, errorDiagnostic: $errorDiagnostic, errorMessage: $errorMessage, finishStatusDescription: $finishStatusDescription, timeoutStatus: $timeoutStatus)';
  }
}