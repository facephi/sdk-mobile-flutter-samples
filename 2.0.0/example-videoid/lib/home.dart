import 'dart:convert';
import 'dart:typed_data';
import 'package:example/widgets/CustomButton.dart';
import 'package:example/widgets/CustomLabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'apis/FacephiServices.dart';
import 'models/CoreWidget.dart';
import 'models/VideoIdResult.dart';
import 'models/VideoIdWidget.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_finish_status.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final CoreWidget _coreWidget              = CoreWidget();
  final VideoIdWidget _videoIdWidget        = VideoIdWidget();

  Uint8List? _bestImage;

  String _tokenFaceImage  = "";
  String _extraData       = "";
  String _message         = '';

  final Color _textColorMessage = const Color(0xFF0099af);

  Map<String, dynamic>? _ocrResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _launchInitSession();
  }

  void _launchInitOperation() async
  {
    final trackingWidgetResult = await _coreWidget.initOperation();
    trackingWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      print("initOperationResult: $r");
    });
  }

  void _launchInitSession() async
  {
    final coreWidgetResult = await _coreWidget.initSession(); // SUCCESS/DENIED
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      final coreResult = r;
      // Manage Plugin process Status
      print(coreResult);
    });
  }

  void _launchCloseSession() async
  {
    final coreWidgetResult = await _coreWidget.closeSession(SdkOperationEvent.SUCCESS); // SUCCESS/DENIED
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      print(r);
    });
  }

  void _launchGetExtraData() async
  {
    final coreWidgetResult = await _coreWidget.getExtraData();
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) async {
      final coreResult = r;
      // Manage Plugin process Status
      print(coreResult);

      if (coreResult.finishStatus == SdkFinishStatus.STATUS_OK) {
        _extraData = coreResult.data!;

        await FacephiServices().livenessRequest(extraData: _extraData, image: base64Encode(_bestImage!))
            .then((value) => print("livenessRequest: $value"))
            .catchError((e) => print("$e"));
        await FacephiServices().matchingFacialRequest(docTemplate: _tokenFaceImage, extraData: _extraData, image: base64Encode(_bestImage!))
            .then((value) => print("matchingFacialRequest: $value"))
            .catchError((e) => print("$e"));
      }
    });
  }

  void _launchTokenize() async
  {
    final tokenizeWidgetResult = await _coreWidget.tokenize();
    tokenizeWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      final tokenizeResult = r;
      // Manage Plugin process Status
      print(tokenizeResult);
    });
  }

  void _launchVideoId() async
  {
    final videoIdWidgetResult = await _videoIdWidget.launchVideoId();
    videoIdWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      final videoIdResult = r;
      // Manage Plugin process Status
      print(videoIdResult);
    });
  }

  void _launchNextStepFlow() async
  {
    final coreWidgetResult = await _coreWidget.nextStepFlow();
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      print(r);
    });
  }

  void _launchCancelFlow() async
  {
    final coreWidgetResult = await _coreWidget.cancelFlow();
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      print(r);
    });
  }

  void _launchFlow() async
  {
    const channel = BasicMessageChannel<dynamic>('core.flow', StringCodec());
    channel.setMessageHandler((message) async
    {
      print(jsonDecode(message!));
      if (jsonDecode(message!)['flow'] == "VIDEOID")
      {
        print(VideoIdResult.fromMap(jsonDecode(message)));
      }
      else
      {
        print(jsonDecode(message));
      }

      return '';
    });

    _coreWidget.initFlow().then((r) async
    {
      r.map((r) async
      {
        if (r.finishStatus == SdkFinishStatus.STATUS_OK)
        {
          await _videoIdWidget.setVideoIdFlow().then((value) => print(value));
          await _coreWidget.startFlow().then((value)
          {
            print(value);
          }
          ).onError((error, stackTrace)
          {
            print(error);
          });
        }
      });
    }
    ).onError((error, stackTrace)
    {
      print(error);
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
                Visibility(visible: _message != "", child: CustomLabel(text: _message, color: _textColorMessage),),
                CustomButton(text: "VideoId", function: _launchVideoId),
                CustomButton(text: "Tokenize", function: _launchTokenize),
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