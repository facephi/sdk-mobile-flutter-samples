import 'dart:convert';
import 'package:example/models/selphid_result.dart';
import 'package:example/models/selphi_face_result.dart';
import 'package:example/widgets/custom_button.dart';
import 'package:example/widgets/custom_label.dart';
import 'package:example/widgets/selphid_image.dart';
import 'package:example/widgets/selphid_list.dart';
import 'package:example/widgets/selphi_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'apis/facephi_services.dart';
import 'models/core_widget.dart';
import 'models/selphid_widget.dart';
import 'models/selphi_face_widget.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_error_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_operation_event.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.notifier, required this.mode});

  final String title;
  final ValueNotifier<ThemeMode> notifier;
  final ThemeMode mode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  Uint8List? _bestImage;
  Uint8List? _frontDocumentImage;
  Uint8List? _backDocumentImage;
  Uint8List? _faceImage;

  String _tokenFaceImage  = "";
  String _extraData       = "";
  String _message         = '';

  Map<String, dynamic>? _ocrResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _launchInitSession();
    _launchListenerTrackingError();
  }

  void _launchSelphIDCapture() async
  {
    final selphIDWidgetResult = await SelphIDWidget().launchSelphIDCapture();
    selphIDWidgetResult.fold((l) {
      setState(() {
        _message            = l.toString();
        _frontDocumentImage = null;
        _backDocumentImage  = null;
        _faceImage          = null;
        _ocrResult          = null;
      });
    }, (r) {
      final selphIDResult = r;
      // Manage Plugin process Status
      switch (selphIDResult.finishStatus) {
        case SdkFinishStatus.STATUS_OK: // OK
          setState(() {
            _message = '';
            _frontDocumentImage = base64Decode(selphIDResult.frontDocumentImage);
            _backDocumentImage  = base64Decode(selphIDResult.backDocumentImage);
            _faceImage          = base64Decode(selphIDResult.faceImage);
            _ocrResult          = json.decode(selphIDResult.documentData);
            _tokenFaceImage     = selphIDResult.tokenFaceImage;
          });
          break;
        case SdkFinishStatus.STATUS_ERROR: // Error
          setState(() {
            _message            = SdkErrorType.getDiagnosticError(selphIDResult.errorDiagnostic);
            _frontDocumentImage = null;
            _backDocumentImage  = null;
            _ocrResult          = null;
            _faceImage          = null;
            _ocrResult          = null;
          });
          break;
      }
    });
  }

  void _launchSelphiAuthenticate() async
  {
    final selphiFaceWidgetResult = await SelphiFaceWidget().launchSelphiAuthenticate();
    selphiFaceWidgetResult.fold((l) {
      setState(() {
        _message    = l.toString();
        _bestImage  = null;
      });
    }, (r) {
      final selphiFaceResult = r;
      // Manage Plugin process Status
      switch (selphiFaceResult.finishStatus) {
        case SdkFinishStatus.STATUS_OK: // OK
          setState(() {
            _message    = '';
            _bestImage  = base64Decode(selphiFaceResult.bestImage!);
          });
          break;
        case SdkFinishStatus.STATUS_ERROR: // Error
          setState(() {
            _message    = SdkErrorType.getDiagnosticError(selphiFaceResult.errorDiagnostic);
            _bestImage  = null;
          });
          break;
      }
    });
  }

  void _launchListenerTrackingError() async
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

  void _launchInitOperation() async
  {
    final trackingWidgetResult = await CoreWidget().initOperation();
    trackingWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      if (kDebugMode) {
        print("initOperationResult: $r");
      }
    });
  }

  void _launchInitSession() async
  {
    final coreWidgetResult = await CoreWidget().initSession(); // SUCCESS/DENIED
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      // Manage Plugin process Status
      if (kDebugMode) {
        print(r);
      }
    });
  }

  void _launchCloseSession() async
  {
    final coreWidgetResult = await CoreWidget().closeSession(SdkOperationEvent.SUCCESS); // SUCCESS/DENIED
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      if (kDebugMode) {
        print(r);
      }
    });
  }

  void _launchGetExtraData() async
  {
    final coreWidgetResult = await CoreWidget().getExtraData();
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) async {
      if (kDebugMode) {
        print(r);
      }

      if (r.finishStatus == SdkFinishStatus.STATUS_OK) {
        _extraData = r.data!;

        await FacephiServices().livenessRequest(extraData: _extraData, image: base64Encode(_bestImage!))
          .then((value) {
            if (kDebugMode) {
              print("livenessRequest: $value");
            }
          })
          .catchError((e) {
            if (kDebugMode) {
              print("$e");
            }
          });
        await FacephiServices().matchingFacialRequest(docTemplate: _tokenFaceImage, extraData: _extraData, image: base64Encode(_bestImage!))
          .then((value) {
            if (kDebugMode) {
              print("matchingFacialRequest: $value");
            }
          })
          .catchError((e) {
            if (kDebugMode) {
              print("$e");
            }
          });
      }
    });
  }

  void _launchNextStepFlow() async
  {
    final coreWidgetResult = await CoreWidget().nextStepFlow();
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      if (kDebugMode) {
        print(r);
      }
    });
  }

  void _launchCancelFlow() async
  {
    final coreWidgetResult = await CoreWidget().cancelFlow();
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      if (kDebugMode) {
        print(r);
      }
    });
  }

  void _launchFlow() async
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: const TextStyle(fontSize: 24, color: Colors.white)),
        actions: [ buildPopupMenuButton() ],
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Visibility(visible: _bestImage != null, child: const CustomLabel(text: "Best Image", color: Color(0xff2196f3))),
                Visibility(visible: _bestImage != null, child: SelphiImage(_bestImage)),
                Visibility(
                  visible: _frontDocumentImage != null || _backDocumentImage != null,
                  child: Column(
                    children: [
                      const CustomLabel(text: "Front", color: Color(0xff2196f3)),
                      SelphIDImage(_frontDocumentImage, 0.25, 1),
                      const CustomLabel(text: "Back", color: Color(0xff2196f3)),
                      SelphIDImage(_backDocumentImage, 0.25, 1),
                      const CustomLabel(text: "Face", color: Color(0xff2196f3)),
                      SelphIDImage(_faceImage, 0.25, 0.25),

                      if (_ocrResult != null && _ocrResult!.length > 1)
                        const CustomLabel(text: "Data", color: Color(0xff2196f3)),
                      if (_ocrResult != null && _ocrResult!.length > 1)
                        SelphIDList(_ocrResult, 0.5, 0.75),
                    ],
                  ),
                ),
                Visibility(visible: _message != "", child: CustomLabel(text: _message, color: const Color(0xFF0099af))),
                CustomButton(text: "Selphi", function: _launchSelphiAuthenticate),
                CustomButton(text: "SelphID", function: _launchSelphIDCapture),
                CustomButton(text: "Get ExtraData", function: _launchGetExtraData),
                CustomButton(text: "Launch Flow", function: _launchFlow),
                CustomButton(text: "Next Step Flow", function: _launchNextStepFlow),
                CustomButton(text: "Cancel Flow", function: _launchCancelFlow),
                CustomButton(text: "Init Operation", function: _launchInitOperation),
                CustomButton(text: "Init Session", function: _launchInitSession),
                CustomButton(text: "Close Session", function: _launchCloseSession),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (String result) {
        if (result == "THEME")
        {
          widget.notifier.value = widget.mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
        }
      },
      itemBuilder: (BuildContext context) =>
      <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "THEME",
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
            leading: Icon(widget.mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode, size: 17.0),
            title: const Text('Elegir Theme'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: "CLOSE",
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
            leading: Icon(Icons.close, size: 17.0),
            title: Text('Close'),
          ),
        ),
      ],
    );
  }
}