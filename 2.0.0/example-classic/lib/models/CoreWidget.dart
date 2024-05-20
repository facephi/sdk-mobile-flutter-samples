import 'dart:io' show Platform;
import 'package:dartz/dartz.dart';
import 'package:example/license.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_operation_event.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tokenize_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_operation_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_flow_configuration.dart';
import 'CoreResult.dart';

/// This sample class calls the Core Plugin and launch the native widget. Return the result to the UI
class CoreWidget
{
  Future<Either<Exception, CoreResult>> closeSession(SdkOperationEvent event) async
  {
    try {
      FphiSdkmobileCore core = FphiSdkmobileCore();

      final Map resultJson = await core.closeSession();
      return Right(CoreResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> initSession() async
  {
    try
    {
      FphiSdkmobileCore core = FphiSdkmobileCore();
      String lic    = (Platform.isAndroid) ? LICENSE_ANDROID : LICENSE_IOS;
      String apiKey = (Platform.isAndroid) ? LICENSE_APIKEY_ANDROID : LICENSE_APIKEY_IOS;

      final Map resultJson = await core.initSession(widgetConfigurationJSON: CoreConfigurationInitSession(
          mLicense: lic,
          //mLicenseUrl: LICENSE_URL,
          //mLicenseApiKey: apiKey,
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
      FphiSdkmobileCore core = FphiSdkmobileCore();
      final Map resultJson = await core.getExtraData();
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
      FphiSdkmobileCore core = FphiSdkmobileCore();

      final Map resultJson = await core.initOperation(
        widgetConfigurationJSON: TrackingConfiguration(mCustomerId: CUSTOMER_ID, mType: TrackingOperationType.ONBOARDING),
      );
      return Right(CoreResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> tokenize() async
  {
    try
    {
      FphiSdkmobileCore core = FphiSdkmobileCore();
      final Map resultJson = await core.tokenize(widgetConfigurationJSON: TokenizeConfiguration(mStringToTokenize: "Something to tokenize ..."));
      return Right(CoreResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, CoreResult>> initFlow() async
  {
    try
    {
      FphiSdkmobileCore core = FphiSdkmobileCore();
      final Map resultJson = await core.initFlow(
          widgetConfigurationJSON: FlowConfiguration(
              mCustomerId: CUSTOMER_ID, mFlow: "770c5d93-20ea-44cd-a848-41666486c5b0"
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
      FphiSdkmobileCore core = FphiSdkmobileCore();
      final Map resultJson = await core.startFlow();
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
      FphiSdkmobileCore core = FphiSdkmobileCore();
      final Map resultJson = await core.cancelFlow();
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
      FphiSdkmobileCore core = FphiSdkmobileCore();
      final Map resultJson = await core.nextStep();
      return Right(CoreResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }
}