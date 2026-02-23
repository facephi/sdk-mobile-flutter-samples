import 'package:dartz/dartz.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_configuration.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_reticle_orientation.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_filter.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_selector_options.dart';
import 'package:fphi_sdkmobile_phingers/fphi_sdkmobile_phingers_selector_hand_orientation.dart';
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
    PhingersConfiguration cfg           = PhingersConfiguration();
    cfg.mReticleOrientation             = PhingersReticleOrientation.DT_LEFT; // LEFT, or RIGHT.
    cfg.mUseLiveness                    = true;
    cfg.mExtractionTimeout              = 50000;
    cfg.mShowTutorial                   = false;
    cfg.mFingersFilter                  = FingersFilter.DT_ALL_5_FINGERS_ONE_BY_ONE;
    cfg.mFingerSelectorHandOrientation  = PhingerSelectorHandOrientation.DT_LEFT;
    // cfg.mFingerSelectorOptions       = [PhingerSelectorOptions.ALL_4_FINGERS_ONE_BY_ONE.toString(), PhingerSelectorOptions.ALL_5_FINGERS_ONE_BY_ONE.toString()];

    return cfg;
  }
}