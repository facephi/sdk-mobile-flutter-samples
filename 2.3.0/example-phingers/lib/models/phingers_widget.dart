import 'package:dartz/dartz.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_configuration.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_filter.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_reticle_orientation.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_selector_hand_orientation.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_selector_options.dart';
import 'phingers_result.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class PhingersWidget
{
  Future<Either<Exception, PhingersResult>> setPhingersFlow() async {
    try
    {
      Map? r = await FphiSdkmobilePhingers().setPhingersFlow();
      return Right(PhingersResult.fromMap(r));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, PhingersResult>> launchPhingers() async {
    try
    {
      Map? r = await FphiSdkmobilePhingers().startPhingersComponent(widgetConfigurationJSON: createStandardConfiguration());
      return Right(PhingersResult.fromMap(r));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration 
  PhingersConfiguration createStandardConfiguration() {
    PhingersConfiguration cfg = PhingersConfiguration();
    cfg.reticleOrientation          = PhingersReticleOrientation.DT_LEFT; // LEFT, RIGHT or THUMB
    cfg.useLiveness                 = true;
    cfg.extractionTimeout           = 30000;
    cfg.showTutorial                = false;
    cfg.fingersFilter               = FingersFilter.DT_ALL_5_FINGERS_ONE_BY_ONE;
    cfg.threshold                   = 0.8;
    cfg.showPreviousFingerSelector  = true;
    cfg.fingerSelectorOptions       = [PhingerSelectorOptions.ALL_4_FINGERS_ONE_BY_ONE, PhingerSelectorOptions.SLAP];
    //cfg.mFingerSelectorHandOrientation  = PhingerSelectorHandOrientation.DT_LEFT;

    return cfg;
  }
}