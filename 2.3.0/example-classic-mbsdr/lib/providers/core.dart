import 'dart:convert';
import 'package:example/models/core_result.dart';
import 'package:example/models/flows_result.dart';
import 'package:example/widgets/flows_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
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

BasicMessageChannel<dynamic>? channel;

void launchInitSession(void Function(VoidCallback fn) setState, ValueNotifier<String> message) async
{
  CoreWidget().initSession().then((res)
  {
    CoreResult r = CoreResult.fromMap(res);
    if (kDebugMode) {
      print(r);
    }
    setState(() {
      if (r.finishStatus == SdkFinishStatus.STATUS_ERROR) {
        message.value = r.errorDiagnostic.toString();
      }
    });
  }).catchError((e) {
    setState(() {
      message.value = e.toString();
    });
  });
}

void launchInitOperation(void Function(VoidCallback fn) setState, ValueNotifier<String> message) async
{
  CoreWidget().initOperation()
  .then((res)
  {
    CoreResult r = CoreResult.fromMap(res);
    if (kDebugMode) {
      print(r);
    }
    setState(() {
      if (r.finishStatus == SdkFinishStatus.STATUS_ERROR) {
        message.value = r.errorDiagnostic.toString();
      }
    });
  })
  .catchError((e) {
    setState(() {
      message.value = e.toString();
    });
  });
}

void launchCloseSession(
    void Function(VoidCallback fn) setState,
    ValueNotifier<String> message,
    SelphIDResult? selphidResult,
    ValueNotifier<Uint8List?> bestImage) async
{
  CoreWidget().closeSession(SdkOperationEvent.SUCCESS)
  .then((res) {
    if (kDebugMode) {
      print("launchCloseSession r: $res");
      setState(() {
        message.value     = "";
        selphidResult     = null;
        bestImage.value   = null;
      });

      if (channel != null) {
        channel?.setMessageHandler(null);
        channel = null;
      }
    }
  }).catchError((e) {
    setState(() {
      message.value = e.toString();
    });
  });
}

void launchGetExtraData(
    void Function(VoidCallback fn) setState,
    ValueNotifier<String> message,
    ValueNotifier<Uint8List?> bestImage,
    String? tokenFaceImage) async
{
  CoreWidget().getExtraData().then((res) async
  {
    CoreResult r = CoreResult.fromMap(res);
    if (r.finishStatus == SdkFinishStatus.STATUS_OK && bestImage.value != null && tokenFaceImage != null)
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
      await FacephiServices().matchingFacialRequest(docTemplate: tokenFaceImage, extraData: r.data!, image: base64Encode(bestImage.value!)).then((value) {
        if (kDebugMode) {
          print("matchingFacialRequest: $value");
        }
      }).catchError((e) {
        if (kDebugMode) {
          print("$e");
        }
      });
    }
  }).catchError((e) {
    setState(() {
      message.value = e.toString();
    });
  });
}

void launchFlow(
    void Function(VoidCallback fn) setState,
    ValueNotifier<String> message,
    ValueNotifier<String> flow) async
{
  channel = BasicMessageChannel<dynamic>('core.flow', StringCodec());
  channel!.setMessageHandler((message) async
  {
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
    else
    {
      if (kDebugMode) {
        print(jsonDecode(message));
      }
    }
    return '';
  });

  CoreWidget().initFlow(flow.value).then((res) async
  {
    CoreResult r = CoreResult.fromMap(res);
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

      CoreWidget().startFlow().then((value)
      {
        if (kDebugMode) {
          print(value);
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print(error);
        }
      });
    }
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

void launchGetFlowIntegrationData(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    ValueNotifier<String> message,
    ValueNotifier<List<FlowsResult>?> flows,
    ValueNotifier<String> flow) async
{
  await CoreWidget().getFlowIntegrationData()
      .then((res)
      {
        CoreResult r = CoreResult.fromMap(res);
        if (r.finishStatus == SdkFinishStatus.STATUS_OK)
        {
          final list = (r.data as List)
              .map((e) => FlowsResult.fromMap(e as Map<dynamic, dynamic>))
              .toList();
          setState(() {
            flows.value = list;
          });
          if (!context.mounted) {
            return;
          }
          showFlowsResultsBottomSheet(context, list, setState, flow);
        }
        else
        {
          setState(() {
            message.value = r.errorDiagnostic;
          });
        }
      })
      .catchError((e) {
        setState(() {
          message.value = e.toString();
        });
      });
}