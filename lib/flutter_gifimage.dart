/*
  author: Jpeng
  email: peng8350@gmail.com
  time:2019-7-26 3:30
*/

library flutter_gifimage;

import 'dart:io';
import 'dart:ui' as ui show Codec;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gifimage/gif_image_info.dart';

/// cache gif fetched image
class GifCache {
  final Map<String, List<GifImageInfo>> caches = Map();

  void clear() {
    caches.clear();
  }

  bool evict(Object key) {
    final List<GifImageInfo> pendingImage = caches.remove(key);
    if (pendingImage != null) {
      return true;
    }
    return false;
  }
}

/// control gif
class GifController extends AnimationController {
  // ignore: unused_field
  double _currentValue = 0;

  GifController({
    @required TickerProvider vsync,
    double value = 0.0,
    Duration reverseDuration,
    Duration duration,
    AnimationBehavior animationBehavior,
    double upperBound,
  }) : super(
          lowerBound: 0.0,
          upperBound: upperBound,
          value: value,
          reverseDuration: reverseDuration,
          duration: duration,
          animationBehavior: animationBehavior ?? AnimationBehavior.normal,
          vsync: vsync,
        );

  GifController.fromGif({
    @required TickerProvider vsync,
    @required Gif gif,
    double value = 0.0,
    AnimationBehavior animationBehavior,
  }) : super(
          lowerBound: 0.0,
          upperBound: gif.length.toDouble(),
          value: value,
          duration: gif.duration,
          reverseDuration: gif.duration,
          animationBehavior: animationBehavior ?? AnimationBehavior.normal,
          vsync: vsync,
        );

  @override
  void reset() {
    value = 0.0;
  }

  TickerFuture repeatFrom({
    double from,
    double min,
    double max,
    bool reverse = false,
    Duration period,
  }) =>
      super.forward(from: from).then((value) =>
          super.repeat(min: min, max: max, reverse: reverse, period: period));

  TickerFuture play({double from, @required bool repeat}) {
    if (repeat) {
      return super.repeat(min: 0, max: this.upperBound);
    }
    return forward(from: from);
  }

  void resume() => throw UnsupportedError('Not yet implemented');

  /// Returns the value of the controller at the moment this method is called.
  @override
  double stop({bool canceled = true}) {
    super.stop(canceled: canceled);
    return _currentValue = value;
  }
}

class GifImage extends StatefulWidget {
  GifImage({
    @required this.image,
    @required this.controller,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.onFetchCompleted,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
  });

  final VoidCallback onFetchCompleted;
  final GifController controller;
  final ImageProvider image;
  final double width;
  final double height;
  final Color color;
  final BlendMode colorBlendMode;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String semanticLabel;
  final bool excludeFromSemantics;

  @override
  State<StatefulWidget> createState() {
    return new GifImageState();
  }

  static GifCache cache = GifCache();
}

class GifImageState extends State<GifImage> {
  Gif gif;
  int _curIndex = 0;
  bool _fetchComplete = false;

  GifImageInfo get _gifImageInfo {
    if (!_fetchComplete) return null;
    return gif == null ? null : gif.imageInfo[_curIndex];
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_listener);
  }

  @override
  void didUpdateWidget(GifImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      fetchGif(widget.image).then((imageInfors) {
        if (mounted)
          setState(() {
            gif = imageInfors;
            _fetchComplete = true;
            _curIndex = widget.controller.value.toInt();
            if (widget.onFetchCompleted != null) {
              widget.onFetchCompleted();
            }
          });
      });
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_listener);
      widget.controller.addListener(_listener);
    }
  }

  void _listener() {
    if (_curIndex != widget.controller.value && _fetchComplete) {
      if (mounted) {
        _curIndex = widget.controller.value.toInt();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (gif == null) {
      fetchGif(widget.image).then((imageInfo) {
        if (mounted)
          setState(() {
            gif = imageInfo;
            _fetchComplete = true;
            _curIndex = widget.controller.value.toInt();
            if (widget.onFetchCompleted != null) {
              widget.onFetchCompleted();
            }
          });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final RawImage image = new RawImage(
      image: _gifImageInfo?.imageInfo?.image,
      width: widget.width,
      height: widget.height,
      scale: _gifImageInfo?.imageInfo?.scale ?? 1.0,
      color: widget.color,
      colorBlendMode: widget.colorBlendMode,
      fit: widget.fit,
      alignment: widget.alignment,
      repeat: widget.repeat,
      centerSlice: widget.centerSlice,
      matchTextDirection: widget.matchTextDirection,
    );

    if (widget.excludeFromSemantics) return image;
    return new Semantics(
      container: widget.semanticLabel != null,
      image: true,
      label: widget.semanticLabel == null ? '' : widget.semanticLabel,
      child: image,
    );
  }
}

final HttpClient _sharedHttpClient = HttpClient()..autoUncompress = false;

HttpClient get _httpClient {
  HttpClient client = _sharedHttpClient;
  assert(() {
    if (debugNetworkImageHttpClientProvider != null)
      client = debugNetworkImageHttpClientProvider();
    return true;
  }());
  return client;
}

Future<Gif> fetchGif(ImageProvider provider) async {
  List<GifImageInfo> frames = [];
  dynamic data;
  String key = provider is NetworkImage
      ? provider.url
      : provider is AssetImage
          ? provider.assetName
          : provider is MemoryImage ? provider.bytes.toString() : "";
  if (GifImage.cache.caches.containsKey(key)) {
    frames = GifImage.cache.caches[key];
    return Gif(frames);
  }

  if (provider is NetworkImage) {
    final Uri resolved = Uri.base.resolve(provider.url);
    final HttpClientRequest request = await _httpClient.getUrl(resolved);
    provider.headers?.forEach((String name, String value) {
      request.headers.add(name, value);
    });
    final HttpClientResponse response = await request.close();
    data = await consolidateHttpClientResponseBytes(
      response,
    );
  } else if (provider is AssetImage) {
    AssetBundleImageKey key = await provider.obtainKey(ImageConfiguration());
    data = await key.bundle.load(key.name);
  } else if (provider is FileImage) {
    data = await provider.file.readAsBytes();
  } else if (provider is MemoryImage) {
    data = provider.bytes;
  }

  ui.Codec codec = await PaintingBinding.instance
      .instantiateImageCodec(data.buffer.asUint8List());
  frames = [];
  for (int i = 0; i < codec.frameCount; i++) {
    FrameInfo frameInfo = await codec.getNextFrame();
    //scale ??
    frames.add(
      GifImageInfo(
        imageInfo: ImageInfo(image: frameInfo.image),
        duration: frameInfo.duration,
      ),
    );
  }
  GifImage.cache.caches.putIfAbsent(key, () => frames);
  return Gif(frames);
}
