import 'package:dartz/dartz.dart';
import 'package:example/models/videoid_result.dart';
import 'package:fphi_sdkmobile_videoid/fphi_sdkmobile_videoid_configuration.dart';
import 'package:fphi_sdkmobile_videoid/fphi_sdkmobile_videoid.dart';
import 'package:fphi_sdkmobile_videoid/fphi_sdkmobile_videoid_mode.dart';

/// This sample class calls the Tracking Plugin and launch the native widget. Return the result to the UI
class VideoIdWidget
{
  Future<Either<Exception, VideoIdResult>> launchSignatureVideoId() async {
    try
    {
      final Map m = await FphiSdkmobileVideoid().startSignatureVideoIdComponent(widgetConfigurationJSON: createStandardConfiguration());
      return Right(VideoIdResult.fromMap(m));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  Future<Either<Exception, VideoIdResult>> launchVideoId() async {
    try
    {
      final Map m = await FphiSdkmobileVideoid().startVideoIdComponent(widgetConfigurationJSON: createStandardConfiguration());
      return Right(VideoIdResult.fromMap(m));
    }
    on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration
  VideoIdConfiguration createStandardConfiguration()
  {
    VideoIdConfiguration cfg  = VideoIdConfiguration();
    cfg.mSectionTime          = 10000;
    cfg.mMode                 = VideoMode.DT_FACE_DOCUMENT_FRONT_BACK;
    // cfg.countryFilter      = ["AR"];
    // cfg.documentFilter     = ["IDC"];
    return cfg;
  }

  Future<Either<Exception, VideoIdResult>> setVideoIdFlow() async
  {
    try
    {
      Map? resultJson = await FphiSdkmobileVideoid().setVideoIdFlow();
      return Right(VideoIdResult.fromMap(resultJson));
    } on Exception catch (e) {
      return (Left(e));
    }
  }
}