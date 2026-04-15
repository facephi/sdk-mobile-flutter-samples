import 'dart:convert';
import 'package:example/models/selphi_face_result.dart';
import 'package:example/models/selphi_face_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';

void launchSelphiAuthenticate(void Function(VoidCallback fn) setState, ValueNotifier<String> message, ValueNotifier<Uint8List?> bestImage) async
{
  SelphiFaceWidget().launchSelphiAuthenticate()
  .then((res)
  {
    SelphiFaceResult r = SelphiFaceResult.fromMap(res);
    setState(() {
      switch (r.finishStatus)
      {
        case SdkFinishStatus.STATUS_OK: // OK
          message.value   = '';
          bestImage.value = base64Decode(r.bestImage!);
          break;
        case SdkFinishStatus.STATUS_ERROR: // Error
          message.value   = SdkErrorType.getDiagnosticError(r.errorDiagnostic);
          bestImage.value = null;
          break;
      }
    });
  })
  .catchError((e) {
    if (kDebugMode) {
      setState(() {
        message.value   = e.toString();
        bestImage.value = null;
      });
    }
  });
}