import 'package:example/widgets/CustomButton.dart';
import 'package:example/widgets/CustomLabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/CoreWidget.dart';
import 'models/VoiceWidget.dart';
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

    _launchInitSession();
  }

  final CoreWidget _coreWidget    = CoreWidget();
  final VoiceWidget _voiceWidget  = VoiceWidget();
  String _message                 = '';

  final Color _textColorMessage = const Color(0xFF0099af);

  void _launchInitOperation() async
  {
    setState(() { _message = ""; });

    final trackingWidgetResult = await _coreWidget.initOperation();
    trackingWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      if (r.finishStatus == SdkFinishStatus.STATUS_ERROR) {
        setState(() {
          _message = r.errorDiagnostic;
        });
      }
      print("initSessionResult: $r");
    });
  }

  void _launchInitSession() async
  {
    setState(() { _message = ""; });

    final coreWidgetResult = await _coreWidget.initSession(); // SUCCESS/DENIED
    coreWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      // Manage Plugin process Status
      if (r.finishStatus == SdkFinishStatus.STATUS_ERROR) {
        setState(() {
          _message = r.errorDiagnostic;
        });
      }
      print("initSessionResult: $r");
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
      setState(() { _message = ""; });
      print("closeSessionResult: $r");
    });
  }

  void _launchVoice() async
  {
    setState(() { _message = ""; });

    final voiceWidgetResult = await _voiceWidget.launchVoice();
    voiceWidgetResult.fold((l) {
      setState(() { _message = l.toString(); });
    }, (r) {
      if (r.finishStatus == SdkFinishStatus.STATUS_ERROR) {
        setState(() {
          _message = r.errorDiagnostic;
        });
      }
      print("launchVoiceResult: $r");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: const TextStyle(fontSize: 24.0, color: Colors.white)),
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
                Visibility(visible: _message != "", child: CustomLabel(text: _message, color: _textColorMessage)),
                CustomButton(text: "Voice", function: _launchVoice),
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