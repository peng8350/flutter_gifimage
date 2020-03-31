import 'package:flutter/cupertino.dart';

class Gif {
  /// The list of frames along with their durations
  final List<GifImageInfo> imageInfo;
  final Duration duration;
  final double width;
  final double height;

  Gif(this.imageInfo)
      : assert(imageInfo.isNotEmpty),
        duration = _getDuration(imageInfo),
        width = imageInfo.first.imageInfo.image.width.toDouble(),
        height = imageInfo.first.imageInfo.image.height.toDouble();

  static Duration _getDuration(List<GifImageInfo> info) {
    return info.fold(Duration(), (value, gifInfo) => value + gifInfo.duration);
  }
}

class GifImageInfo {
  final ImageInfo imageInfo;
  final Duration duration;

  GifImageInfo({@required this.imageInfo, @required this.duration});
}
