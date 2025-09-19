import 'package:dartz/dartz.dart';
import 'package:fphi_sdkmobile_nfc/fphi_sdkmobile_nfc_configuration.dart';
import 'package:fphi_sdkmobile_nfc/fphi_sdkmobile_nfc.dart';
import 'nfc_result.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class NfcWidget
{
  Future<Either<Exception, NfcResult>> launchNfc() async {
    try
    {
      Map? resultJson = await FphiSdkmobileNfc().startNfcComponent(
          widgetConfigurationJSON: NfcConfiguration(
            mBirthDate: "16/08/1979",
            mDocNumber: "YB7606398",
            mExpirationDate: "09/11/2030",
            mShowTutorial: true,
            mVibrationEnabled: true,
            mDocType: NfcDocumentType.PASSPORT
          )
      );
      return Right(NfcResult.fromMap(resultJson));
    }
    on Exception catch (e)
    {
      return (Left(e));
    }
  }

  Future<Either<Exception, NfcResult>> setNfcFlow() async
  {
    try
    {
      Map? resultJson = await FphiSdkmobileNfc().setNfcFlow();
      return Right(NfcResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }
}