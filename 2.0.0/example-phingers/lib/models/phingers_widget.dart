import 'package:dartz/dartz.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_configuration.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_reticle_orientation.dart';
import 'phingers_result.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class PhingersWidget
{
  Future<Either<Exception, PhingersResult>> setPhingersFlow() async {
    try
    {
      Map? resultJson = await FphiSdkmobilePhingers().setPhingersFlow();
      return Right(PhingersResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, PhingersResult>> launchPhingers() async {
    return launchPhingersWithConfiguration(createStandardConfiguration());
  }

  Future<Either<Exception, PhingersResult>>
    launchPhingersWithConfiguration(PhingersConfiguration configuration) async {
    try
    {
      Map? resultJson = await FphiSdkmobilePhingers().startPhingersComponent(widgetConfigurationJSON: configuration);
      return Right(PhingersResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration 
  PhingersConfiguration createStandardConfiguration() {
    PhingersConfiguration configurationWidget;
    configurationWidget = PhingersConfiguration();
    configurationWidget.mReticleOrientation   = PhingersReticleOrientation.DT_LEFT; // LEFT, RIGHT or THUMB
    configurationWidget.mReturnFullFrameImage = true;
    configurationWidget.mReturnProcessedImage = true;
    configurationWidget.mReturnRawImage       = true;
    configurationWidget.mUseFlash             = true;
    configurationWidget.mUseLiveness          = true;
    configurationWidget.mExtractionTimeout    = 5000;
    configurationWidget.mShowTutorial         = false;
    return configurationWidget;
  }
}