import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_configuration.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_document_type.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_capture_mode.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_timeout.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class SelphIDWidget
{
  Future launchSelphIDCapture(SelphIDConfiguration configuration) async
  {
    dynamic r = await FphiSdkmobileSelphid().startSelphIDWidget(widgetConfigurationJSON: configuration);
    return r;
  }

  /// Sample of standard plugin configuration 
  SelphIDConfiguration createStandardConfiguration() {
    SelphIDConfiguration cfg    = SelphIDConfiguration();
    cfg.documentTypes           = [SelphIDDocumentType.DT_IDCARD]; // IDCard, Passport, DriverLic or ForeignCard
    cfg.captureMode             = SelphIDCaptureMode.STANDARD;
    cfg.showResultAfterCapture  = true;
    cfg.timeout                 = SelphIDTimeout.T_SHORT;
    cfg.showDiagnostic          = true;
    cfg.jpgQuality              = 95;
    //cfg.videoFilename         = "/storage/self/primary/Download/videoNameSelphid.mp4";
    return cfg;
  }

  Future setSelphidFlow() async
  {
    dynamic r = await FphiSdkmobileSelphid().setSelphidFlow();
    return r;
  }
}