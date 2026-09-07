import 'package:example/models/selphid_result.dart';
import 'package:example/models/selphid_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';

void launchSelphIDCapture(
    void Function(VoidCallback fn) setState,
    ValueNotifier<String> message,
    ValueNotifier<SelphIDResult?> selphidResult) async
{
  SelphIDWidget().launchSelphIDCapture()
  .then((res) {
    SelphIDResult r = SelphIDResult.fromMap(res);
    setState(()
    {
      switch (r.finishStatus)
      {
        case SdkFinishStatus.STATUS_OK: // OK
          message.value       = '';
          selphidResult.value = r;
          break;
        case SdkFinishStatus.STATUS_ERROR: // Error
          message.value       = SdkErrorType.getDiagnosticError(r.errorDiagnostic);
          selphidResult.value = null;
          break;
      }
    });
  })
  .catchError((e) {
    setState(() {
      message.value       = e.toString();
      selphidResult.value = null;
    });
  });
}