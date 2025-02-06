import 'dart:io' show Platform;
import 'package:dartz/dartz.dart';
import 'package:example/license.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_operation_event.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_operation_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_flow_configuration.dart';
import 'core_result.dart';

/// This sample class calls the Core Plugin and launch the native widget. Return the result to the UI
class CoreWidget
{
  Future<Either<Exception, CoreResult>> closeSession(SdkOperationEvent event) async
  {
    try {
      final Map resultJson = await FphiSdkmobileCore().closeSession();
      return Right(CoreResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> initSession() async
  {
    try
    {
      String lic    = (Platform.isAndroid) ? licenseAndroid : licenseIOS;
      String apiKey = (Platform.isAndroid) ? licenseApiKeyAndroid : licenseApiKeyIOS;

      final Map resultJson = await FphiSdkmobileCore().initSession(widgetConfigurationJSON: CoreConfigurationInitSession(
          //mLicense: lic,
          mLicenseUrl: licenseUrl,
          mLicenseApiKey: apiKey,
          mEnableTracking: true
      ));

      return Right(CoreResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> getExtraData() async
  {
    try
    {
      final Map resultJson = await FphiSdkmobileCore().getExtraData();
      return Right(CoreResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> initOperation() async
  {
    try
    {
      final Map resultJson = await FphiSdkmobileCore().initOperation(
        widgetConfigurationJSON: TrackingConfiguration(mCustomerId: customerId, mType: TrackingOperationType.ONBOARDING),
      );
      return Right(CoreResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> initFlow() async
  {
    try
    {
      final Map resultJson = await FphiSdkmobileCore().initFlow(
          widgetConfigurationJSON: FlowConfiguration(
              mCustomerId: customerId, mFlow: "770c5d93-20ea-44cd-a848-41666486c5b0"
          )
      );
      return Right(CoreResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> startFlow() async
  {
    try
    {
      final Map resultJson = await FphiSdkmobileCore().startFlow();
      return Right(CoreResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> cancelFlow() async
  {
    try
    {
      final Map resultJson = await FphiSdkmobileCore().cancelFlow();
      return Right(CoreResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> nextStepFlow() async
  {
    try
    {
      final Map resultJson = await FphiSdkmobileCore().nextStep();
      return Right(CoreResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }
}