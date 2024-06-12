import 'package:dartz/dartz.dart';
import 'package:fphi_sdkmobile_nfc/fphi_sdkmobile_nfc_configuration.dart';
import 'package:fphi_sdkmobile_nfc/fphi_sdkmobile_nfc.dart';
import 'NfcResult.dart';

/// This sample class calls the Selphi Plugin and launch the native widget. Return the result to the UI
class NfcWidget
{
  Future<Either<Exception, NfcResult>> launchNfc() async {
    try
    {
      FphiSdkmobileNfc nfc = FphiSdkmobileNfc();
      Map? resultJson = await nfc.startNfcComponent(
          widgetConfigurationJSON: NfcConfiguration(
            mBirthDate: "16/08/1979",
            mDocNumber: "AAI372468",
            mExpirationDate: "15/11/2032"
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
      FphiSdkmobileNfc nfc = FphiSdkmobileNfc();
      Map? resultJson = await nfc.setNfcFlow();

      return Right(NfcResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }
}