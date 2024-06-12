import 'dart:core';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';

class NfcResult
{
  final SdkFinishStatus finishStatus;
  final String finishStatusDescription;
  final String errorDiagnostic;
  final String? errorMessage;
  final int timeoutStatus;
  final String facialImage;
  final String fingerprintImage;
  final String signatureImage;
  final dynamic nfcDocumentInformation;
  final dynamic nfcRawData;
  final dynamic nfcSecurityData;
  final dynamic nfcValidations;
  final dynamic nfcPersonalInformation;
  //final dynamic nfcCertificateData;

  const NfcResult({
    required this.finishStatus,
    required this.finishStatusDescription,
    required this.errorDiagnostic,
    required this.errorMessage,
    required this.timeoutStatus,
    //required this.nfcCertificateData,
    required this.facialImage,
    required this.signatureImage,
    required this.fingerprintImage,
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
      'errorDiagnostic': errorDiagnostic ?? "",
      'errorMessage': errorMessage ?? "",
      'timeoutStatus': timeoutStatus,
      //'nfcCertificateData': nfcCertificateData,
      'facialImage': facialImage,
      'signatureImage': signatureImage,
      'fingerprintImage': fingerprintImage,
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
      //nfcCertificateData: map['nfcCertificateData'] ?? "",
      facialImage: map['facialImage'] ?? "",
      signatureImage: map['signatureImage'] ?? "",
      fingerprintImage: map['fingerprintImage'] ?? "",
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