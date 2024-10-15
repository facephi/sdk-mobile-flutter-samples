import 'package:dartz/dartz.dart';
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi_configuration.dart';
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi_liveness_mode.dart';
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi.dart';
import 'SelphiFaceResult.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class SelphiFaceWidget
{
  Future<Either<Exception, SelphiFaceResult>> launchSelphiAuthenticate(String resourcesPath) async
  {
    try
    {
      FphiSdkmobileSelphi selphi = FphiSdkmobileSelphi();
      final Map resultJson = await selphi.startSelphiFaceWidget(resourcesPath: resourcesPath, widgetConfigurationJSON: createStandardConfiguration());
      return Right(SelphiFaceResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration
  SelphiFaceConfiguration createStandardConfiguration()
  {
    SelphiFaceConfiguration configurationWidget;
    configurationWidget = SelphiFaceConfiguration();
    configurationWidget.livenessMode  = SelphiFaceLivenessMode.LM_PASSIVE; // Liveness mode
    configurationWidget.fullscreen    = true;
    configurationWidget.logImages     = false;
    configurationWidget.jpgQuality    = 0.95;
    configurationWidget.enableGenerateTemplateRaw = true;
    //configurationWidget.videoFilename           = "/storage/self/primary/Download/videoName.mp4";
    return configurationWidget;
  }

  Future<Either<Exception, SelphiFaceResult>> setSelphiFlow() async
  {
    try
    {
      FphiSdkmobileSelphi selphi = FphiSdkmobileSelphi();
      final Map resultJson = await selphi.setSelphiFlow();

      return Right(SelphiFaceResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }
}