import 'dart:convert';
import 'package:example/models/selphid_result.dart';
import 'package:example/providers/core.dart';
import 'package:example/providers/selphi.dart';
import 'package:example/providers/selphid.dart';
import 'package:example/widgets/custom_button.dart';
import 'package:example/widgets/custom_label.dart';
import 'package:example/widgets/custom_popup_menu_button.dart';
import 'package:example/widgets/selphid_image.dart';
import 'package:example/widgets/selphid_list.dart';
import 'package:example/widgets/selphi_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final ValueNotifier<Uint8List?> _bestImage          = ValueNotifier(null);
  final ValueNotifier<SelphIDResult?> _selphIDResult  = ValueNotifier(null);
  final ValueNotifier<String> _message                = ValueNotifier("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    launchInitSession(setState, _message);
    launchListenerTrackingError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: const TextStyle(fontSize: 24, color: Colors.white)),
        actions: [ CustomPopupMenuBtn(widget: widget) ],
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SelphiImage(_bestImage.value),
                Visibility(
                  visible: _selphIDResult.value?.frontDocumentImage != null || _selphIDResult.value?.backDocumentImage != null,
                  child: Column(
                    children: [
                      SelphIDImage("Front", _selphIDResult.value?.frontDocumentImage, 0.25, 0.75),
                      SelphIDImage("Back", _selphIDResult.value?.backDocumentImage, 0.25, 0.75),
                      SelphIDImage("Face", _selphIDResult.value?.faceImage, 0.25, 0.50),
                      SelphIDList(_selphIDResult.value?.documentData == null ? null : json.decode(_selphIDResult.value!.documentData), 0.5, 0.75),
                    ],
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: ValueNotifier<String>(_message.value),
                  builder: (BuildContext context, String value, child) {
                    return Visibility(visible: value != "", child: CustomLabel(text: value, color: const Color(0xFF0099af)));
                  },
                ),
                CustomButton(text: "Selphi", function: () => launchSelphiAuthenticate(setState, _message, _bestImage)),
                CustomButton(text: "SelphID", function: () => launchSelphIDCapture(setState, _message, _selphIDResult)),
                Visibility(
                  visible: _bestImage.value != null && _selphIDResult.value?.tokenFaceImage != null,
                  child: CustomButton(text: "Get ExtraData", function: () => launchGetExtraData(setState, _message, _bestImage, _selphIDResult.value?.tokenFaceImage))
                ),
                CustomButton(text: "Launch Flow", function: launchFlow),
                CustomButton(text: "Next Step Flow", function: () => launchNextStepFlow(setState, _message)),
                CustomButton(text: "Cancel Flow", function: () => launchCancelFlow(setState, _message)),
                CustomButton(text: "Init Operation", function: () => launchInitOperation(setState, _message)),
                CustomButton(text: "Init Session", function: () => launchInitSession(setState, _message)),
                CustomButton(text: "Close Session", function: () => launchCloseSession(setState, _message, _selphIDResult, _bestImage)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}