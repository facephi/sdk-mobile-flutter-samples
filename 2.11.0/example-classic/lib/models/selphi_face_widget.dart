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
    SelphiFaceConfiguration cfg   = SelphiFaceConfiguration();
    cfg.livenessMode              = SelphiFaceLivenessMode.LM_PASSIVE; // Liveness mode
    cfg.fullscreen                = true;
    cfg.logImages                 = false;
    cfg.jpgQuality                = 0.95;
    cfg.enableGenerateTemplateRaw = true;
    cfg.showPreviousTip           = false;
    cfg.showTutorial              = false;
    // cfg.params                 = {"DesiredCameraWidth": "1280", "DesiredCameraHeight": "720"};
    //cfg.videoFilename           = "/storage/self/primary/Download/videoName.mp4";
    return cfg;
  }

  Future setSelphiFlow() async
  {
      dynamic r = await FphiSdkmobileSelphi().setSelphiFlow();
      return r;
  }
}