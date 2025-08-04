import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';
import 'package:example/models/core_widget.dart';
import 'package:example/models/selphi_face_result.dart';
import 'package:example/models/selphi_face_widget.dart';
import 'package:example/models/selphid_result.dart';
import 'package:example/models/selphid_widget.dart';
import 'package:example/apis/facephi_services.dart';
import 'package:flutter/foundation.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_operation_event.dart';

void launchInitSession(void Function(VoidCallback fn) setState, ValueNotifier<String> message) async
{
  final coreWidgetResult = await CoreWidget().initSession(); // SUCCESS/DENIED
  coreWidgetResult.fold((l) {
    setState(() {
      message.value = l.toString();
    });
  }, (r) {
    if (kDebugMode) {
      print("launchInitSession r: $r");
      setState(() {
        if (r.finishStatus == SdkFinishStatus.STATUS_ERROR) {
          message.value = r.errorDiagnostic.toString();
        }
      });
    }
  });
}

void launchInitOperation(void Function(VoidCallback fn) setState, ValueNotifier<String> message) async
{
  final tracking = await CoreWidget().initOperation();
  tracking.fold((l) {
    setState(() {
      message.value = l.toString();
    });
  }, (r) {
    if (kDebugMode) {
      print("launchInitOperation r: $r");
      setState(() {
        if (r.finishStatus == SdkFinishStatus.STATUS_ERROR) {
          message.value = r.errorDiagnostic.toString();
        }
      });
    }
  });
}

void launchCloseSession(void Function(VoidCallback fn) setState, ValueNotifier<String> message) async
{
  final coreWidgetResult = await CoreWidget().closeSession(SdkOperationEvent.SUCCESS); // SUCCESS/DENIED
  coreWidgetResult.fold((l) {
    setState(() {
      message.value = l.toString();
    });
  }, (r) {
    if (kDebugMode) {
      print("launchCloseSession r: $r");
      setState(() {
        message.value = "";
      });
    }
  });
}

void launchGetExtraData(
    void Function(VoidCallback fn) setState,
    ValueNotifier<String> message,
    ValueNotifier<Uint8List?> bestImage,
    ValueNotifier<String> tokenFaceImage) async
{
  final coreResult = await CoreWidget().getExtraData();
  coreResult.fold((l) {
    setState(() {
      message.value = l.toString();
    });
  }, (r) async {
    if (kDebugMode) {
      print(r);
    }

    if (r.finishStatus == SdkFinishStatus.STATUS_OK && bestImage.value != null)
    {
      await FacephiServices().livenessRequest(extraData: r.data!, image: base64Encode(bestImage.value!)).then((value) {
        if (kDebugMode) {
          print("livenessRequest: $value");
        }
      }).catchError((e) {
        if (kDebugMode) {
          print("$e");
        }
      });
      await FacephiServices().matchingFacialRequest(docTemplate: tokenFaceImage.value, extraData: r.data!, image: base64Encode(bestImage.value!)).then((value) {
        if (kDebugMode) {
          print("matchingFacialRequest: $value");
        }
      }).catchError((e) {
        if (kDebugMode) {
          print("$e");
        }
      });
    }
  });
}

void launchCancelFlow(void Function(VoidCallback fn) setState, ValueNotifier<String> message) async
{
  final coreResult = await CoreWidget().cancelFlow();
  coreResult.fold((l) {
    setState(() {
      message.value = l.toString();
    });
  }, (r) {
    if (kDebugMode) {
      print(r);
    }
  });
}

void launchNextStepFlow(void Function(VoidCallback fn) setState, ValueNotifier<String> message) async
{
  final coreResult = await CoreWidget().nextStepFlow();
  coreResult.fold((l) {
    setState(() {
      message.value = l.toString();
    });
  }, (r) {
    if (kDebugMode) {
      print(r);
    }
  });
}

void launchFlow() async
{
  const channel = BasicMessageChannel<dynamic>('core.flow', StringCodec());
  channel.setMessageHandler((message) async
  {
    if (kDebugMode) {
      print(jsonDecode(message!));
    }
    if (jsonDecode(message!)['flow'] == "SELPHID")
    {
      if (kDebugMode) {
        print(SelphIDResult.fromMap(jsonDecode(message)));
      }
    }
    else if (jsonDecode(message!)['flow'] == "SELPHI")
    {
      if (kDebugMode) {
        print(SelphiFaceResult.fromMap(jsonDecode(message)));
      }
    }
    return '';
  });

  CoreWidget().initFlow().then((r) async
  {
    r.map((r) async
    {
      if (r.finishStatus == SdkFinishStatus.STATUS_OK)
      {
        await SelphiFaceWidget().setSelphiFlow().then((value) {
          if (kDebugMode) {
            print(value);
          }
        });
        await SelphIDWidget().setSelphidFlow().then((value) {
          if (kDebugMode) {
            print(value);
          }
        });

        await CoreWidget().startFlow().then((value) {
          if (kDebugMode) {
            print(value);
          }
        }).onError((error, stackTrace) {
          if (kDebugMode) {
            print(error);
          }
        });
      }
    });
  }).onError((error, stackTrace) {
    if (kDebugMode) {
      print(error);
    }
  });
}

void launchListenerTrackingError() async
{
  const channel = BasicMessageChannel<dynamic>('tracking.error.listener', StringCodec());
  channel.setMessageHandler((message) async
  {
    if (kDebugMode) {
      print('tracking.error.listener: ${jsonDecode(message!)}');
    }
    return '';
  });
}