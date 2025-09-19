import 'package:dartz/dartz.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_configuration.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_filter.dart';
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
    try
    {
      Map? resultJson = await FphiSdkmobilePhingers().startPhingersComponent(widgetConfigurationJSON: createStandardConfiguration());
      return Right(PhingersResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration 
  PhingersConfiguration createStandardConfiguration() {
    PhingersConfiguration configurationWidget = PhingersConfiguration();
    configurationWidget.mReticleOrientation   = PhingersReticleOrientation.DT_LEFT; // LEFT, RIGHT or THUMB
    configurationWidget.mUseLiveness          = true;
    configurationWidget.mExtractionTimeout    = 10000;
    configurationWidget.mShowTutorial         = false;
    configurationWidget.mFingersFilter        = FingersFilter.DT_ALL_4_FINGERS_ONE_BY_ONE;
    return configurationWidget;
  }
}