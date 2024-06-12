import 'package:dartz/dartz.dart';
import 'package:example/models/VideoIdResult.dart';
import 'package:fphi_sdkmobile_videoid/fphi_sdkmobile_videoid_configuration.dart';
import 'package:fphi_sdkmobile_videoid/fphi_sdkmobile_videoid.dart';
import 'package:fphi_sdkmobile_videoid/fphi_sdkmobile_videoid_mode.dart';

/// This sample class calls the Tracking Plugin and launch the native widget. Return the result to the UI
class VideoIdWidget
{
  Future<Either<Exception, VideoIdResult>> launchVideoId() async {
    return launchVideoIdWithConfiguration(createStandardConfiguration());
  }

  Future<Either<Exception, VideoIdResult>>
    launchVideoIdWithConfiguration(VideoIdConfiguration configuration) async {
    try
    {
      FphiSdkmobileVideoid videoId = FphiSdkmobileVideoid();
      final Map resultJson = await videoId.startVideoIdComponent(widgetConfigurationJSON: configuration);

      return Right(VideoIdResult.fromMap(resultJson));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration
  VideoIdConfiguration createStandardConfiguration()
  {
    VideoIdConfiguration configurationWidget;
    configurationWidget = VideoIdConfiguration();
    configurationWidget.mTime         = 10;
    configurationWidget.mMode         = VideoMode.DT_FACE_DOCUMENT_FRONT_BACK;
    configurationWidget.mShowTutorial = false;
    return configurationWidget;
  }

  Future<Either<Exception, VideoIdResult>> setVideoIdFlow() async {
    try
    {
      FphiSdkmobileVideoid videoid = FphiSdkmobileVideoid();
      Map? resultJson = await videoid.setVideoIdFlow();

      return Right(VideoIdResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }
}