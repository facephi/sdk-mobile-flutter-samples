import 'dart:io' show Platform;
import 'package:example/license.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_operation_event.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_operation_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_flow_configuration.dart';

/// This sample class calls the Core Plugin and launch the native widget. Return the result to the UI
class CoreWidget
{
  Future closeSession(SdkOperationEvent event) async
  {
    dynamic r = await FphiSdkmobileCore().closeSession();
    return r;
  }

  Future initSession() async
  {
    dynamic r = await FphiSdkmobileCore().initSession(widgetConfigurationJSON: CoreConfigurationInitSession(
        //mLicense: (Platform.isAndroid) ? licenseAndroid : licenseIOS,
        mLicenseUrl: licenseUrl,
        mLicenseApiKey: (Platform.isAndroid) ? licenseApiKeyAndroid : licenseApiKeyIOS,
        mEnableTracking: true
    ));
    return r;
  }

  Future getExtraData() async
  {
    dynamic r = await FphiSdkmobileCore().getExtraData();
    return r;
  }

  Future initOperation() async
  {
    dynamic r = await FphiSdkmobileCore().initOperation(
      widgetConfigurationJSON: TrackingConfiguration(mCustomerId: customerId, mType: TrackingOperationType.ONBOARDING),
    );
    return r;
  }

  Future initFlow() async
  {
    dynamic r = await FphiSdkmobileCore().initFlow(
        widgetConfigurationJSON: FlowConfiguration(
            mCustomerId: customerId, mFlow: "770c5d93-20ea-44cd-a848-41666486c5b0"
        )
    );
    return r;
  }

  Future startFlow() async
  {
    dynamic r = await FphiSdkmobileCore().startFlow();
    return r;
  }

  Future cancelFlow() async
  {
    dynamic r = await FphiSdkmobileCore().cancelFlow();
    return r;
  }

  Future nextStepFlow() async
  {
    dynamic r = await FphiSdkmobileCore().nextStep();
    return r;
  }
}