import 'package:dartz/dartz.dart';
import 'package:fphi_sdkmobile_voice/fphi_sdkmobile_voice_configuration.dart';
import 'package:fphi_sdkmobile_voice/fphi_sdkmobile_voice.dart';
import 'VoiceResult.dart';

/// This sample class calls the Tracking Plugin and launch the native widget. Return the result to the UI
class VoiceWidget
{
  Future<Either<Exception, VoiceResult>> setVoiceFlow() async {
    try
    {
      FphiSdkmobileVoice voice = FphiSdkmobileVoice();
      Map? resultJson = await voice.setVoiceFlow();

      return Right(VoiceResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, VoiceResult>> launchVoice() async {
    return launchVoiceWithConfiguration(createStandardConfiguration());
  }

  Future<Either<Exception, VoiceResult>> launchVoiceWithConfiguration(VoiceConfiguration configuration) async {
    try
    {
      FphiSdkmobileVoice voice = FphiSdkmobileVoice();
      final Map resultJson = await voice.startVoiceComponent(widgetConfigurationJSON: configuration);

      return Right(VoiceResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration
  VoiceConfiguration createStandardConfiguration()
  {
    VoiceConfiguration configurationWidget;
    configurationWidget = VoiceConfiguration();
    configurationWidget.mVibrationEnabled = true;
    configurationWidget.mShowTutorial     = true;
    configurationWidget.mPhrases          = "Hola hello world|Chau voice component|Hola voice component";

    return configurationWidget;
  }
}