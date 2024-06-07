import 'package:example/widgets/CustomButton.dart';
import 'package:example/widgets/CustomLabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/CoreWidget.dart';
import 'models/PhingersWidget.dart';
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

  final PhingersWidget _phingersWidget  = PhingersWidget();
  final CoreWidget _coreWidget          = CoreWidget();

  String _message               = '';
  final Color _textColorMessage = const Color(0xFF0099af);

  void _launchPhingers() async
  {
    final phingersWidgetResult = await _phingersWidget.launchPhingers();
    phingersWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
      });
    }, (r) {
      print(r);
      // Manage Plugin process Status
      switch (r.finishStatus) {
        case SdkFinishStatus.STATUS_OK: // OK
          setState(() { _message = ''; });
          break;
        case SdkFinishStatus.STATUS_ERROR: // Error
          setState(() {
            _message = r.errorDiagnostic;
          });
          break;
      }
    });
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
                Visibility(visible: _message != "", child: CustomLabel(text: _message, color: _textColorMessage)),
                CustomButton(text: "Phingers", function: _launchPhingers),
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