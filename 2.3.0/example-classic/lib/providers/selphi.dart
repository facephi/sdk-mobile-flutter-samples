import 'dart:convert';
import 'package:example/models/selphi_face_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';

void launchSelphiAuthenticate(void Function(VoidCallback fn) setState, ValueNotifier<String> message, ValueNotifier<Uint8List?> bestImage) async
{
  final selphiResult = await SelphiFaceWidget().launchSelphiAuthenticate();
  selphiResult.fold((l) {
    setState(() {
      message.value   = l.toString();
      bestImage.value = null;
    });
  }, (r) {
    switch (r.finishStatus) {
      case SdkFinishStatus.STATUS_OK: // OK
        setState(() {
          message.value   = '';
          bestImage.value = base64Decode(r.bestImage!);
        });
        break;
      case SdkFinishStatus.STATUS_ERROR: // Error
        setState(() {
          message.value   = SdkErrorType.getDiagnosticError(r.errorDiagnostic);
          bestImage.value = null;
        });
        break;
    }
  });
}