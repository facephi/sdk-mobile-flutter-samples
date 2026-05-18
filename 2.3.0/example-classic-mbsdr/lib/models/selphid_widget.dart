import 'package:example/license.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_configuration.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_document_type.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_scan_mode.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_timeout.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class SelphIDWidget
{
  Future launchSelphIDCapture() async
  {
    dynamic r = await FphiSdkmobileSelphid().startSelphIDWidget(resourcesPath: resourcesPathSelphid, widgetConfigurationJSON: createStandardConfiguration());
    return r;
  }

  /// Sample of standard plugin configuration 
  SelphIDConfiguration createStandardConfiguration() {
    SelphIDConfiguration cfg    = SelphIDConfiguration();
    cfg.documentType            = SelphIDDocumentType.DT_IDCARD; // IDCard, Passport, DriverLic or ForeignCard
    cfg.fullscreen              = true;
    cfg.scanMode                = SelphIDScanMode.CAP_MODE_SEARCH;
    cfg.specificData            = 'AR|<ALL>';
    cfg.showResultAfterCapture  = true;
    cfg.timeout                 = SelphIDTimeout.T_SHORT;
    cfg.showDiagnostic          = true;
    cfg.wizardMode              = true;
    //cfg.params                = { 'PromiscuousMode': 'None'};
    //cfg.videoFilename         = "/storage/self/primary/Download/videoNameSelphid.mp4";
    return cfg;
  }

  Future setSelphidFlow() async
  {
    dynamic r = await FphiSdkmobileSelphid().setSelphidFlow();
    return r;
  }
}