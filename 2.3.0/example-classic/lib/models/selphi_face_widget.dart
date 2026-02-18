import 'package:example/license.dart';
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi_configuration.dart';
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi_liveness_mode.dart';
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class SelphiFaceWidget
{
  Future launchSelphiAuthenticate() async
  {
    dynamic r = await FphiSdkmobileSelphi().startSelphiFaceWidget(resourcesPath: resourcesPath, widgetConfigurationJSON: createStandardConfiguration());
    return r;
  }

  /// Sample of standard plugin configuration
  SelphiFaceConfiguration createStandardConfiguration()
  {
    SelphiFaceConfiguration configurationWidget   = SelphiFaceConfiguration();
    configurationWidget.livenessMode              = SelphiFaceLivenessMode.LM_PASSIVE; // Liveness mode
    configurationWidget.fullscreen                = true;
    configurationWidget.logImages                 = false;
    configurationWidget.jpgQuality                = 0.95;
    configurationWidget.enableGenerateTemplateRaw = true;
    configurationWidget.showPreviousTip           = false;
    configurationWidget.showTutorial              = false;
    // configurationWidget.params                 = {"DesiredCameraWidth": "1280", "DesiredCameraHeight": "720"};
    //configurationWidget.videoFilename           = "/storage/self/primary/Download/videoName.mp4";
    return configurationWidget;
  }

  Future setSelphiFlow() async
  {
      dynamic r = await FphiSdkmobileSelphi().setSelphiFlow();
      return r;
  }
}