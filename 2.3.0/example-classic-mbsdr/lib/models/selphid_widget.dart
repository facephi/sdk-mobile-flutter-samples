import 'package:dartz/dartz.dart';
import 'package:example/license.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_configuration.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_document_side.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_document_type.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_scan_mode.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_timeout.dart';
import 'selphid_result.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class SelphIDWidget
{
  Future<Either<Exception, SelphIDResult>> launchSelphIDCapture() async
  {
    try
    {
      final Map r = await FphiSdkmobileSelphid().startSelphIDWidget(resourcesPath: resourcesPathSelphid, widgetConfigurationJSON: createStandardConfiguration());
      return Right(SelphIDResult.fromMap(r));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration 
  SelphIDConfiguration createStandardConfiguration() {
    SelphIDConfiguration configurationWidget    = SelphIDConfiguration();
    configurationWidget.documentType            = SelphIDDocumentType.DT_IDCARD; // IDCard, Passport, DriverLic or ForeignCard
    configurationWidget.fullscreen              = true;
    configurationWidget.scanMode                = SelphIDScanMode.CAP_MODE_SEARCH;
    configurationWidget.specificData            = 'AR|<ALL>';
    configurationWidget.showResultAfterCapture  = true;
    configurationWidget.timeout                 = SelphIDTimeout.T_SHORT;
    configurationWidget.showDiagnostic          = true;
    configurationWidget.wizardMode              = true;
    //configurationWidget.videoFilename         = "/storage/self/primary/Download/videoNameSelphid.mp4";
    return configurationWidget;
  }

  Future<Either<Exception, SelphIDResult>> setSelphidFlow() async {
    try
    {
      final Map r = await FphiSdkmobileSelphid().setSelphidFlow();
      return Right(SelphIDResult.fromMap(r));
    } on Exception catch (e) {
      return (Left(e));
    }
  }
}