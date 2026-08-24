import 'dart:io' show Platform;
import 'package:dartz/dartz.dart';
import 'package:example/license.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_operation_event.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_operation_type.dart';
import 'core_result.dart';

/// This sample class calls the Core Plugin and launch the native widget. Return the result to the UI
class CoreWidget
{
  Future<Either<Exception, CoreResult>> closeSession(SdkOperationEvent event) async
  {
    try
    {
      final Map r = await FphiSdkmobileCore().closeSession();
      return Right(CoreResult.fromMap(r));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> initSession() async
  {
    try
    {
      CoreConfigurationInitSession cfg = CoreConfigurationInitSession();
      // cfg.license          = (Platform.isAndroid) ? licenseAndroid : licenseIOS;
      cfg.licenseUrl          = licenseUrl;
      cfg.licenseApiKey       = (Platform.isAndroid) ? licenseApiKeyAndroid : licenseApiKeyIOS;
      cfg.enableTracking      = true;
      // cfg.internalOptions  = {"SKIP_ENV_CHECK": "true"};
      // cfg.orientation      = SdkViewOrientation.followSystem;

      final Map m = await FphiSdkmobileCore().initSession(widgetConfigurationJSON: cfg);

      return Right(CoreResult.fromMap(m));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> getExtraData() async
  {
    try
    {
      final Map r = await FphiSdkmobileCore().getExtraData();
      return Right(CoreResult.fromMap(r));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> initOperation() async
  {
    try
    {
      final Map r = await FphiSdkmobileCore().initOperation(
        widgetConfigurationJSON: TrackingConfiguration(mCustomerId: customerId, mType: TrackingOperationType.ONBOARDING),
      );
      return Right(CoreResult.fromMap(r));
    } on Exception catch (e) {
      return (Left(e));
    }
  }
}