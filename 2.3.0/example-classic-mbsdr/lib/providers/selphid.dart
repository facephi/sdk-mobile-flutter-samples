import 'dart:convert';
import 'package:example/models/selphid_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';

void launchSelphIDCapture(
    void Function(VoidCallback fn) setState,
    ValueNotifier<String> message,
    ValueNotifier<Uint8List?> frontDocumentImage,
    ValueNotifier<Uint8List?> backDocumentImage,
    ValueNotifier<Uint8List?> faceImage,
    ValueNotifier<Map<String, dynamic>?> ocrResult,
    ValueNotifier<String> tokenFaceImage) async
{
  final selphIDResult = await SelphIDWidget().launchSelphIDCapture();
  selphIDResult.fold((l) {
    setState(() {
      message.value             = l.toString();
      frontDocumentImage.value  = null;
      backDocumentImage.value   = null;
      faceImage.value           = null;
      ocrResult.value           = null;
    });
  }, (r) {
    // Manage Plugin process Status
    switch (r.finishStatus) {
      case SdkFinishStatus.STATUS_OK: // OK
        setState(() {
          message.value             = '';
          frontDocumentImage.value  = base64Decode(r.frontDocumentImage);
          backDocumentImage.value   = base64Decode(r.backDocumentImage);
          faceImage.value           = base64Decode(r.faceImage);
          ocrResult.value           = json.decode(r.documentData);
          tokenFaceImage.value      = r.tokenFaceImage;
        });
        break;
      case SdkFinishStatus.STATUS_ERROR: // Error
        setState(() {
          message.value             = SdkErrorType.getDiagnosticError(r.errorDiagnostic);
          frontDocumentImage.value  = null;
          backDocumentImage.value   = null;
          ocrResult.value           = null;
          faceImage.value           = null;
          ocrResult.value           = null;
        });
        break;
    }
  });
}